import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _currentSliderValue = 0;
  Duration _duration = Duration();
  Duration _position = Duration();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
  }

  void toggleIsPlaying() {
    isPlaying = !isPlaying;
  }

  void _playAudio() async {
    await _audioPlayer.play(UrlSource(
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3'));
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 30, 107, 125)),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '😍',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Container(
              height: 100,
              width: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Listen to your feelings',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: isPlaying
                            ? Icon(Icons.stop_sharp)
                            : Icon(Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            _pauseAudio();
                          } else {
                            _playAudio();
                          }
                          toggleIsPlaying();
                        },
                      ),
                      Slider(
                        value: _position.inSeconds.toDouble(),
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
