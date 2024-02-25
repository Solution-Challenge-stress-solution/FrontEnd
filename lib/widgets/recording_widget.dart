import 'package:flutter/material.dart';
import 'package:strecording/utilities/record_manager.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({
    Key? key,
    required this.toggleIsRecording,
    required this.isRecording,
    required this.toggleIsLoading,
    required this.openModal,
    required this.setDiaryText,
    required this.setFilePath,
    required this.currentDate,
  }) : super(key: key);

  final VoidCallback toggleIsRecording;
  final bool isRecording;
  final VoidCallback toggleIsLoading;
  final VoidCallback openModal;
  final void Function(String) setDiaryText;
  final void Function(String) setFilePath;
  final DateTime currentDate;

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  final today = DateTime.now().toString().split(' ')[0];

  void handlePress() {
    // Allow recording only when trying to record for today
    if (widget.currentDate.toString().split(' ')[0] == today) {
      if (!widget.isRecording) {
        RecordManager.startRecord();
      } else {
        RecordManager.stopRecord().then((path) {
          widget.toggleIsLoading();
          RecordManager.postFile(path).then((res) {
            widget.toggleIsLoading();
            widget.setFilePath(path);
            widget.setDiaryText(res);
            widget.openModal();
          });
        });
      }

      widget.toggleIsRecording();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can record a diary only for today, $today'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3CADAB);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.isRecording
              ? primaryColor
              : const Color.fromARGB(255, 255, 252, 248),
          //borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: IconButton(
            iconSize: 24,
            icon: widget.isRecording
                ? Image.asset('assets/images/recording.png')
                : Image.asset('assets/images/record_idle.png'),
            onPressed: handlePress),
      ),
    );
  }
}
