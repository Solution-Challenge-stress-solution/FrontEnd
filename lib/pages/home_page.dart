import 'package:flutter/material.dart';
import 'package:strecording/widgets/audioplayer_widget.dart';
import 'package:strecording/widgets/stress_level.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigateToDiaryPage});

  final VoidCallback navigateToDiaryPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRecorded = false;

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
                  ? defaultTodaysDiary(widget.navigateToDiaryPage)
                  : const Column(children: <Widget>[
                      SizedBox(
                          width: 400, height: 180, child: AudioPlayerWidget()),
                      Text('Daily Stress Level',
                          style: TextStyle(
                            fontFamily: 'Dongle',
                            fontWeight: FontWeight.normal,
                            fontSize: 60,
                          )),
                      StressLevelWidget(),
                    ]),
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
