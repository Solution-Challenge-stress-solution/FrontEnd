import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:strecording/widgets/recording_widget.dart';
import 'package:strecording/widgets/calendar_widget.dart';
import 'package:strecording/widgets/menu_widget.dart';
import 'package:strecording/widgets/loading_widget.dart';
import 'package:strecording/widgets/modal_widget.dart';
import 'package:strecording/utilities/token_manager.dart';
import 'package:strecording/utilities/diary_entry.dart';
import 'package:strecording/widgets/audioplayer_widget.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool isRecording = false;
  bool _isLoading = false;
  bool _isModalOpen = false;
  String? _filePath;
  String _diaryText = '';
  DiaryEntry? _diaryEntry;
  late DateTime _currentDate;
  late TextEditingController _controller;

  void toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void openModal() {
    setState(() {
      _isModalOpen = true;
    });
  }

  void closeModal() {
    setState(() {
      _isModalOpen = false;
    });
  }

  void setDiaryText(String text) {
    setState(() {
      _diaryText = text;
    });
    _controller.text = text;
  }

  void setFilePath(String path) {
    setState(() {
      _filePath = path;
    });
  }

  void setDiaryEntry(Map<String, dynamic>? diary) {
    setState(() {
      if (diary != null) {
        _diaryEntry = DiaryEntry.fromJson(diary);
      } else {
        _diaryEntry = null;
      }
    });
  }

  void setCurrentDate(DateTime selectedDate) {
    setState(() {
      _currentDate = selectedDate;
    });
  }

  DateTime getCurrentDate() {
    return _currentDate;
  }

  void toggleIsRecording() {
    setState(() {
      isRecording = !isRecording;
    });
  }

  Future<void> fetchDiary() async {
    String dailyDate = _currentDate.toString().split(' ')[0];
    final requestUrl = 'http://strecording.shop:8080/diaries/$dailyDate';

    try {
      final res = await http.get(Uri.parse(requestUrl),
          headers: TokenManager.getHeaders());
      final resJson = json.decode(utf8.decode(res.bodyBytes));

      if (resJson['status'] == 'SUCCESS') {
        setDiaryText(resJson['data']['content']);
        setFilePath(resJson['data']['audioFileUrl']);
        setDiaryEntry(resJson['data']);
      } else {
        setDiaryText('');
        setDiaryEntry(null);
        print('Failed to fetch diary: $resJson');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postDiary(String path, String text) async {
    toggleIsLoading();
    const requestUrl = 'http://strecording.shop:8080/diaries';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(requestUrl),
    )
      ..fields['content'] = text
      ..files.add(await http.MultipartFile.fromPath(
        'audioFile',
        path,
        contentType: MediaType('audio', 'x-flac'),
      ));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${TokenManager.getToken()}',
    });

    try {
      final streamRes = await request.send();
      final streamResJson =
          json.decode(utf8.decode(await streamRes.stream.toBytes()));
      print(streamResJson);

      if (streamResJson['status'] == 'SUCCESS') {
        setDiaryText(text);
        postPrediction(path, streamResJson['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postPrediction(String path, int id) async {
    final requestUrl =
        'http://strecording.shop:8080/emotion/prediction/diaries/${id.toString()}';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(requestUrl),
    )..files.add(await http.MultipartFile.fromPath(
        'audioFile',
        path,
        contentType: MediaType('audio', 'x-flac'),
      ));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${TokenManager.getToken()}',
    });

    try {
      final streamRes = await request.send();
      final streamResJson =
          json.decode(utf8.decode(await streamRes.stream.toBytes()));
      print(streamResJson);

      if (streamRes.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Today's diary has been successfully recorded"),
            duration: Duration(seconds: 3),
          ),
        );
        fetchDiary();
        toggleIsLoading();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteDiary(int? diaryId) async {
    if (diaryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary cannot be deleted because it is empty!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      final requestUrl = 'http://strecording.shop:8080/diaries/$diaryId';
      final res = await http.delete(Uri.parse(requestUrl),
          headers: TokenManager.getHeaders());
      final resJson = json.decode(utf8.decode(res.bodyBytes));

      if (resJson['status'] == 'SUCCESS') {
        print(resJson);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diary has been successfully deleted!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diary cannot be deleted!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setCurrentDate(DateTime.now());
    _controller = TextEditingController(text: _diaryText);
    fetchDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                buildDiaryHeader(),
                const SizedBox(height: 16),
                buildDateDisplay(),
                Expanded(
                  child: Center(
                    child: _diaryEntry != null
                        ? SizedBox(
                            width: 400,
                            height: 100,
                            child: AudioPlayerWidget(
                                key: ValueKey(_diaryEntry!.diaryId),
                                filePath: _diaryEntry!.audioFileUrl),
                          )
                        : const SizedBox
                            .shrink(), // Use SizedBox.shrink() to avoid taking space when there is no audio player
                  ),
                ),
                buildDiaryTextField(),
                const SizedBox(height: 110),
              ],
            ),
          ),
          if (isRecording)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          if (_isLoading) const LoadingWidget(),
          if (_isModalOpen)
            ModalWidget(
                closeModal: closeModal,
                initialText: _diaryText,
                filePath: _filePath.toString(),
                postDiary: postDiary),
          Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              height: 80,
              child: RecordingWidget(
                toggleIsRecording: toggleIsRecording,
                isRecording: isRecording,
                toggleIsLoading: toggleIsLoading,
                openModal: openModal,
                setDiaryText: setDiaryText,
                setFilePath: setFilePath,
                currentDate: _currentDate,
              )),
        ],
      ),
    );
  }

  Widget buildDiaryHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Diary',
            style: TextStyle(
              fontFamily: 'Dongle',
              fontSize: 60,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: CalendarWidget(
                      setCurrentDate: setCurrentDate,
                      getCurrentDate: getCurrentDate,
                      modalContext: context),
                );
              },
            ).then((_) {
              fetchDiary();
            });
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 48,
            height: 48,
            child: MenuWidget(
              diaryId: _diaryEntry?.diaryId,
              fetchDiary: fetchDiary,
              deleteDiary: deleteDiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateDisplay() {
    return Expanded(
      child: Center(
        child: Text(DateFormat('yyyy.MM.dd').format(getCurrentDate()),
            style: const TextStyle(
                fontFamily: 'Dongle',
                fontSize: 36,
                fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget buildDiaryTextField() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 241, 213),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        enabled: false,
        controller: _controller,
        maxLines: null,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
