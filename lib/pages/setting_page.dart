import 'package:flutter/material.dart';
import 'package:strecording/widgets/profile_widget.dart';
import 'package:strecording/widgets/settings_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage(
      {super.key,
      required this.email,
      required this.name,
      required this.profileImg});

  final String email;
  final String name;
  final String profileImg;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Profile',
              style: TextStyle(
                fontFamily: 'Dongle',
                fontWeight: FontWeight.normal,
                fontSize: 60,
              )),
          ProfileWidget(
              email: widget.email,
              name: widget.name,
              profileImg: widget.profileImg),
          const Text('Profile',
              style: TextStyle(
                fontFamily: 'Dongle',
                fontWeight: FontWeight.normal,
                fontSize: 60,
              )),
          const Expanded(child: SettingsWidget()),
        ],
      ),
    ));
  }
}
