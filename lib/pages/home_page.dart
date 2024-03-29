import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:strecording/utilities/token_manager.dart';
import 'package:strecording/widgets/audioplayer_widget.dart';
import 'package:strecording/widgets/emotions_widget.dart';
import 'package:strecording/widgets/activitycard_widget.dart';
import 'package:strecording/utilities/diary_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigateToDiaryPage});

  final VoidCallback navigateToDiaryPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRecorded = true;
  Activity? myActivity;
  DiaryEntry? _diaryEntry;

  void setDiaryEntry(Map<String, dynamic> diary) {
    setState(() {
      _diaryEntry = DiaryEntry.fromJson(diary);
    });
  }

  Future<void> fetchDiary() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final requestUrl = 'http://strecording.shop:8080/diaries/$formattedDate';
    final res = await http.get(Uri.parse(requestUrl),
        headers: TokenManager.getHeaders());
    final resJson = json.decode(utf8.decode(res.bodyBytes));

    if (resJson['status'] == 'SUCCESS') {
      setState(() {
        isRecorded = true;
      });
      setDiaryEntry(resJson['data']);
      fetchActivity(resJson['data']['activityId']);
    } else {
      isRecorded = false;
      print('Failed to fetch diary: $resJson');
    }
  }

  Future<void> fetchActivity(int activityId) async {
    var url = Uri.parse('http://strecording.shop:8080/activities/$activityId');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final activityJson = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          myActivity = Activity.fromJson(activityJson['data']);
        });
      } else {
        print('Failed to fetch activity: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Today's diary",
                  style: TextStyle(
                    fontFamily: 'Dongle',
                    fontWeight: FontWeight.normal,
                    fontSize: 60,
                  )),
              isRecorded && _diaryEntry != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Container(
                              width: 400,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 30, 107, 125)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AudioPlayerWidget(
                                  filePath: _diaryEntry!.audioFileUrl)),
                          const SizedBox(height: 20),
                          const Text('Daily Stress Level',
                              style: TextStyle(
                                fontFamily: 'Dongle',
                                fontWeight: FontWeight.normal,
                                fontSize: 60,
                              )),
                          EmotionsWidget(
                              h: _diaryEntry!.happiness,
                              a: _diaryEntry!.angry,
                              s: _diaryEntry!.sadness,
                              d: _diaryEntry!.disgusting,
                              f: _diaryEntry!.fear,
                              stressLevel: _diaryEntry!.stressPoint),
                          const SizedBox(height: 20),
                          const Text(
                            "Today's Activity",
                            style: TextStyle(
                              fontFamily: 'Dongle',
                              fontWeight: FontWeight.normal,
                              fontSize: 60,
                            ),
                          ),
                          if (myActivity != null)
                            ActivityCard(activity: myActivity!),
                        ])
                  : defaultTodaysDiary(widget.navigateToDiaryPage),
            ],
          ),
        ),
      ),
    );
  }
}

Widget defaultTodaysDiary(VoidCallback navigateToDiaryPage) {
  return Container(
    height: 360,
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 30, 107, 125)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          "You haven’t made today.. Would you like to do it now?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
            width: 200,
            height: 50,
            child: OutlinedButton(
              onPressed: navigateToDiaryPage,
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  side: const BorderSide(
                    width: 2,
                    color: Color.fromARGB(255, 60, 173, 171),
                  )),
              child: const Text('Go to Diary',
                  style: TextStyle(
                      color: Color.fromARGB(255, 60, 173, 171),
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            )),
      ],
    ),
  );
}
