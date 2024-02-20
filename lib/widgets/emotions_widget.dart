import 'package:flutter/material.dart';

class Emotion {
  final String name;
  final String emoji;
  final double value;

  Emotion(this.name, this.emoji, this.value);
}

class EmotionsWidget extends StatelessWidget {
  const EmotionsWidget(
      {super.key,
      required this.h,
      required this.a,
      required this.s,
      required this.d,
      required this.f,
      required this.stressLevel});

  final double h;
  final double a;
  final double s;
  final double d;
  final double f;
  final double stressLevel;

  // give me code

  @override
  Widget build(BuildContext context) {
    final emotions = [
      Emotion('Happy', '😍', h),
      Emotion('Angry', '😠', a),
      Emotion('Sad', '😢', s),
      Emotion('Disgusted', '🤢', d),
      Emotion('Feared', '😨', f),
    ];

    // Sort the emotions in descending order by value
    emotions.sort((a, b) => b.value.compareTo(a.value));

    // Create emotion rows from the sorted list
    final emotionRows = emotions
        .asMap()
        .entries
        .map((entry) => EmotionRow(
              emotion: entry.value.name,
              emoji: entry.value.emoji,
              rank: entry.key + 1, // +1 because rank should start from 1
            ))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 30, 107, 125)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: emotionRows,
            ),
          ),
          StressLevelIndicator(stressLevel: stressLevel),
        ],
      ),
    );
  }
}

class EmotionRow extends StatelessWidget {
  const EmotionRow(
      {super.key,
      required this.emotion,
      required this.emoji,
      required this.rank});

  final String emotion;
  final String emoji;
  final int rank;

  @override
  Widget build(BuildContext context) {
    double fontSize = rank == 1 ? 40 : 24;
    TextStyle textStyle = rank == 1
        ? const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 250, 170, 5))
        : const TextStyle(fontSize: 18);

    return Container(
      width: 160,
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$rank. $emotion', style: textStyle),
          Text(
            emoji,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class StressLevelIndicator extends StatelessWidget {
  const StressLevelIndicator({super.key, required this.stressLevel});

  final double stressLevel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: 270,
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 255, 210, 116)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Stress Level',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: LinearProgressIndicator(
                    value: stressLevel / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 60, 173, 171),
                    ),
                    minHeight: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
