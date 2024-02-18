import 'package:flutter/material.dart';
import 'package:strecording/widgets/profile_widget.dart';
import 'package:strecording/widgets/settings_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Profile',
              style: TextStyle(
                fontFamily: 'Dongle',
                fontWeight: FontWeight.normal,
                fontSize: 60,
              )),
          ProfileWidget(),
          SizedBox(height: 34),
          Text('Settings',
              style: TextStyle(
                fontFamily: 'Dongle',
                fontWeight: FontWeight.normal,
                fontSize: 60,
              )),
          Expanded(child: SettingsWidget()),
        ],
      ),
    ));
  }
}
