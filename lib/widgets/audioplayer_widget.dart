import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key, required this.filePath});

  final String filePath;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio(widget.filePath);
  }

  Future<void> _initAudio(String filePath) async {
    File? file = await downloadFile(filePath, 'diary.flac');

    try {
      await _audioPlayer.setFilePath(file!.path);
    } catch (e) {
      print(e);
      print('filePath: $file');
    }
  }

  // Convert google bucket url into an actual file url
  Future<File?> downloadFile(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final response = await http.get(Uri.parse(url));

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      print('Err while downloading audio file');
      print(e);
      return null;
    }
  }

  void toggleIsPlaying() {
    isPlaying = !isPlaying;
  }

  void _playAudio() async {
    await _audioPlayer.play();
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      width: 32.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: _playAudio,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: _pauseAudio,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () => _audioPlayer.seek(Duration.zero),
                    );
                  }
                },
              ),
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;
                  return Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
