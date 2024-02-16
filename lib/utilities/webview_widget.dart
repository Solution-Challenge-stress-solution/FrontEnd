import 'package:strecording/utilities/login_platform.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuthWebView extends StatefulWidget {
  OAuthWebView(
      {super.key, required this.navigateToHome, required this.redirectUrl});

  final VoidCallback navigateToHome;
  final String redirectUrl;

  @override
  _OAuthWebViewState createState() => _OAuthWebViewState();
}

class _OAuthWebViewState extends State<OAuthWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onUrlChange: (url) {
        if (url.url!.startsWith('http://34.64.90.112')) {
          List<String> parts = url.url!.split('=');
          String code = parts
              .last; // This gets the last element of the list, which should be the code
          AuthManager.signInWithKakao(code);
          Navigator.pop(context);
          widget.navigateToHome();
        }
      }))
      ..loadRequest(
        Uri.parse(widget.redirectUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
