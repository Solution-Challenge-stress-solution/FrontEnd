import 'package:flutter/material.dart';

class StressLevelWidget extends StatelessWidget {
  const StressLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 30, 107, 125)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Text(
            "Today's Stress Level",
            style: TextStyle(
              color: Color(0xFF1E6B7D),
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 24),
          StressLevelBar(label: 'HAPPY', percentage: 5),
          StressLevelBar(
            label: 'SAD',
            percentage: 20,
          ),
          StressLevelBar(label: 'ANXIOUS', percentage: 50),
          StressLevelBar(label: 'ANGERY', percentage: 95),
        ],
      ),
    );
  }
}

class StressLevelBar extends StatelessWidget {
  final String label;
  final double percentage; // Value between 0.0 and 1.0

  const StressLevelBar(
      {super.key, required this.label, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate the width available for the bar
          final double maxWidth =
              constraints.maxWidth - 10 - 80; // 10 for SizedBox, 80 for Text
          final double barWidth = maxWidth * (percentage / 100);

          return Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  Container(
                    height: 20,
                    width: maxWidth,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(100, 255, 210, 116),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: barWidth,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 170, 5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
