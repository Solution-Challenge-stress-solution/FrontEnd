import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    const oneSec = Duration(milliseconds: 50);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_progress >= 1) {
        timer.cancel();
        // Once the progress is complete, navigate to another screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'STREcording')));
      } else {
        setState(() {
          _progress += 0.01;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it is still running
    super.dispose();
  }

  String _getLoadingText() {
    int percentage = (_progress * 100).round();
    return 'LOADING... $percentage%';
  }

  @override
  Widget build(BuildContext context) {
    const Color progressColor = Color(0xFFFFD274);
    const Color progressBackgroundColor = Color(0xFFFAAA05);
    const Color darkerPrimaryColor = Color(0xFF1E6B7D);

    return Scaffold(
      backgroundColor: const Color(0xFF3CADAB),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Image.asset(
            'assets/images/mainlogo.png',
            width: 128,
            height: 128,
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Dongle',
                fontSize: 60,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'STRE', style: TextStyle(color: darkerPrimaryColor)),
                TextSpan(text: 'cording', style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          const SizedBox(height: 128),
          Text(
            _getLoadingText(),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: progressColor,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(progressBackgroundColor),
            ),
          ),
          const SizedBox(height: 180),
        ],
      ),
    );
  }
}
