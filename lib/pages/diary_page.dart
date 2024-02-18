import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:strecording/widgets/recording_widget.dart';
import 'package:strecording/widgets/calendar_widget.dart';
import 'package:strecording/widgets/menu_widget.dart';
import 'package:strecording/widgets/loading_widget.dart';
import 'package:strecording/widgets/modal_widget.dart';
import 'package:strecording/utilities/token_manager.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool isRecording = false;
  bool _isLoading = false;
  bool _isModalOpen = false;
  String _diaryText = '';
  DateTime _currentDate = DateTime.now();
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
      final res =
          await http.get(Uri.parse(requestUrl), headers: TokenManager.headers);
      final resJson = json.decode(utf8.decode(res.bodyBytes));
      setDiaryText(resJson['data']['content']);
    } catch (e) {
      print(e);
      setDiaryText('');
    } finally {
      _controller.text = _diaryText;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _diaryText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDiaryHeader(),
                const SizedBox(height: 16),
                buildDateDisplay(),
                const SizedBox(height: 200),
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
            ModalWidget(closeModal: closeModal, initialText: _diaryText),
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
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: CalendarWidget(
                      setCurrentDate: setCurrentDate,
                      getCurrentDate: getCurrentDate,
                      modalContext: context),
                );
              },
            ).then((_) {
              //setState(() {});
              fetchDiary();
            });
          },
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: 48, height: 48, child: MenuWidget())),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 241, 213),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
