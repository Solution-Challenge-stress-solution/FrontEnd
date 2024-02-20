import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final String imageUrl;

  Activity(
      {required this.title, required this.description, required this.imageUrl});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] as String,
      description: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color.fromARGB(255, 30, 107, 125)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: const Color.fromARGB(255, 60, 173, 171),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      activity.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Dongle',
                        fontSize: 40,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Image.network(
                activity.imageUrl,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 255, 210, 116),
              child: Text(
                activity.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
