import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Today's diary",
                style: TextStyle(
                  fontFamily: 'Dongle',
                  fontWeight: FontWeight.normal,
                  fontSize: 60,
                )),
          ],
        ),
      ),
    );
  }
}
