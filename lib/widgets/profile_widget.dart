import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/token_manager.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late String _email = '@';
  late String _name = 'Unknown User';
  String _profileImg = 'assets/images/profile.png'; // Default value

  Future<void> _getUserInfo() async {
    const requestUrl = 'http://strecording.shop:8080/user/info';
    final response = await http.get(Uri.parse(requestUrl),
        headers: TokenManager.getHeaders());
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _email = responseJson['data']['email'];
      _name = responseJson['data']['name'];
      _profileImg = responseJson['data']['profileImage'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 46,
          backgroundImage: _profileImg.startsWith('http')
              ? NetworkImage(_profileImg)
              : AssetImage(_profileImg) as ImageProvider,
          backgroundColor: const Color.fromARGB(255, 255, 251, 255),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                _email,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
