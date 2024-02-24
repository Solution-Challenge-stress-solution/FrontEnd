import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strecording/pages/login_page.dart';
import 'package:strecording/utilities/login_platform.dart';
import 'package:strecording/utilities/notification_manager.dart';
import 'dart:io';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;
      final int? storedHour = prefs.getInt('notificationHour');
      final int? storedMinute = prefs.getInt('notificationMinute');
      if (storedHour != null && storedMinute != null) {
        selectedTime = TimeOfDay(hour: storedHour, minute: storedMinute);
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', isNotificationEnabled);
    await prefs.setInt('notificationHour', selectedTime.hour);
    await prefs.setInt('notificationMinute', selectedTime.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      await _savePreferences();
    }
  }

  bool isNotificationEnabled = false;
  TimeOfDay selectedTime = const TimeOfDay(hour: 1, minute: 1);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
           ListTile(
             title: const Text('Diary notification'),
             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 if (isNotificationEnabled)
                   Container(
                     margin: const EdgeInsets.only(left: 16),
                     child: OutlinedButton(
                       onPressed: () => _selectTime(context),
                       style: OutlinedButton.styleFrom(
                         side: const BorderSide(
                             color: Color.fromARGB(255, 255, 251, 255)),
                         padding: const EdgeInsets.symmetric(
                             horizontal: 8, vertical: 4),
                       ),
                       child: Text(
                         selectedTime.format(context),
                         style: const TextStyle(
                           color: Color(0xFF3CADAB),
                           fontSize: 14,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ),
                 Switch(
                   value: isNotificationEnabled,
                   onChanged: (bool value) async {
                     setState(() {
                       isNotificationEnabled = value;
                     });
                     await _savePreferences();
                     if (value) {
                       // Android에서는 알림 권한 요청이 필요 없습니다.
                       if (Platform.isIOS) {
                         NotificationManager.requestNotificationPermission();
                       }
                       // 알림 설정이 적용되었다는 메시지를 표시합니다.
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('알림 설정이 적용되었습니다(영어로 바꿔줄것)')),
                       );
                     }
                   },
                 ),
               ],
             ),
           ),
          ListTile(
            title: const Text('Sign out'),
            onTap: () async {
              final bool signOutSuccessful = await AuthManager.signOut();

              // Check if the widget is still in the tree and can be interacted with.
              if (!mounted) return;

              if (signOutSuccessful) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have been succesfully logged out'),
                    duration: Duration(seconds: 3),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                // Handle sign-out failure
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error! Failed to log out'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
           ListTile(
             title: const Text('Delete account'),
             onTap: () async {
               final bool confirmDelete = await showDialog(
                 context: context,
                 builder: (BuildContext context) {
                   return AlertDialog(
                     title: const Text('Confirm Delete'),
                     content: const Text('Are you sure you want to delete your account?'),
                     actions: <Widget>[
                       TextButton(
                         child: const Text('Cancel'),
                         onPressed: () => Navigator.of(context).pop(false),
                       ),
                       TextButton(
                         child: const Text('Delete'),
                         onPressed: () => Navigator.of(context).pop(true),
                       ),
                     ],
                   );
                 },
               );

               if (confirmDelete) {
                 final bool deleteSuccessful = await AuthManager.deleteAccount();

                 if (!mounted) return;

                 if (deleteSuccessful) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Your account has been successfully deleted'),
                       duration: Duration(seconds: 3),
                     ),
                   );
                   Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (context) => const LoginPage()),
                   );
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Error! Failed to delete your account'),
                       duration: Duration(seconds: 3),
                     ),
                   );
                 }
               }
             },
           ),
        ],
      ),
    );
  }
}
