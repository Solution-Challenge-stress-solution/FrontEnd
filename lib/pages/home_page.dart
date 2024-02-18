import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:strecording/utilities/token_manager.dart';
import 'package:strecording/widgets/audioplayer_widget.dart';
import 'package:strecording/widgets/stress_level.dart';
import 'package:strecording/widgets/activitycard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigateToDiaryPage});

  final VoidCallback navigateToDiaryPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRecorded = true; //false;
  String _filePath = '';
  Activity? myActivity;

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
    } else {
      isRecorded = false;
      print(resJson);
    }
  }

  Future<void> fetchActivity(int argument) async {
    var url = Uri.parse('http://34.64.90.112:8080/api/activities/$argument');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final activityJson = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          myActivity = Activity.fromJson(activityJson['data']);
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiary();

    if (isRecorded) {
      fetchActivity(1);
    } else {
      setState(() {
        myActivity = null;
      });
    }
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
              isRecorded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          SizedBox(
                              width: 400,
                              height: 120,
                              child: AudioPlayerWidget(filePath: _filePath)),
                          const SizedBox(height: 20),
                          const Text('Daily Stress Level',
                              style: TextStyle(
                                fontFamily: 'Dongle',
                                fontWeight: FontWeight.normal,
                                fontSize: 60,
                              )),
                          const StressLevelWidget(),
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
