import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget(
      {super.key,
      required this.email,
      required this.name,
      required this.profileImg});

  final String email;
  final String name;
  final String profileImg;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 46,
          backgroundImage: widget.profileImg.startsWith('http')
              ? NetworkImage(widget.profileImg)
              : AssetImage(widget.profileImg) as ImageProvider,
          backgroundColor: const Color.fromARGB(255, 255, 251, 255),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.email,
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
