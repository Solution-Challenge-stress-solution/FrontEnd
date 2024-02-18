import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/token_manager.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key, required this.diaryId});

  final int? diaryId;

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  Future<void> _deleteDiary() async {
    if (widget.diaryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Diary cannot be deleted because it has not been made yet!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      final requestUrl =
          'http://strecording.shop:8080/diaries/${widget.diaryId}';
      final res = await http.delete(Uri.parse(requestUrl),
          headers: TokenManager.getHeaders());
      final resJson = json.decode(utf8.decode(res.bodyBytes));
      if (resJson['status'] == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diary has been successfully deleted!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diary cannot be deleted!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        _deleteDiary();
      },
      itemBuilder: (BuildContext context) {
        return {'delete': 'Delete Diary'}.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList();
      },
      child: Icon(Icons.more_vert),
    );
  }
}
