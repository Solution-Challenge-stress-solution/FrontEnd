import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/token_manager.dart';

class ModalWidget extends StatefulWidget {
  const ModalWidget(
      {super.key, required this.closeModal, required this.initialText});

  final VoidCallback closeModal;
  final String initialText;

  @override
  State<ModalWidget> createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<ModalWidget> {
  late TextEditingController _controller;

  void _handleSubmit() {
    final inputText = _controller.text;
    print('Submitted text: $inputText');
    widget.closeModal();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the modal compact
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(179, 255, 210, 116),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 150, // Set the maximum height for the TextField
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: TextField(
                      controller: _controller,
                      maxLines: null, // Set maxLines to null for auto-expansion
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove TextField border
                        hintText: 'Input text here',
                        contentPadding:
                            EdgeInsets.all(16), // Padding inside the box
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(48), // Set the button's height
                    primary: Colors.teal, // Set the button's background color
                  ),
                  child: const Text('확인',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
