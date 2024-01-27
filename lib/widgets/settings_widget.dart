import 'package:flutter/material.dart';
import 'package:strecording/pages/login_page.dart';
import 'package:strecording/utilities/login_platform.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: const Text('Diary notification'),
            trailing: Switch(
              value: true, // This should be a state variable
              onChanged: (bool value) {
                // Handle switch toggle
              },
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
            onTap: () {
              // Handle account deletion
            },
          ),
        ],
      ),
    );
  }
}
