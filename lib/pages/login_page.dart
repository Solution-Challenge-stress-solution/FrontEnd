import 'package:flutter/material.dart';
import 'package:strecording/main.dart';
import 'package:strecording/utilities/login_platform.dart';
import 'package:strecording/widgets/webview_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 76),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/main_logo.png',
              height: 160,
            ),
            const SizedBox(height: 36),
            const Text(
              'LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Dongle',
                fontSize: 65,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                AuthManager.signInWithGoogle(_navigateToHome);
              },
              style: btnStyle('google'),
              child: Image.asset('assets/images/google_login.png'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // Allows the modal to take full screen height if needed
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.8,
                      child: OAuthWebView(
                        navigateToHome: _navigateToHome,
                        redirectUrl:
                            'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=3ea1d757fe280fdf11868685602c24d0&redirect_uri=http://34.64.90.112:8080/login/oauth2/code/kakao',
                      ),
                    );
                  },
                );
              },
              style: btnStyle('kakao'),
              child: Image.asset('assets/images/kakao_login.png',
                  fit: BoxFit.fitWidth, width: 245),
            ),
          ],
        ),
      ),
    );
  }
}

ButtonStyle btnStyle(String platform) {
  BorderRadius borderRadious =
      platform == 'kakao' ? BorderRadius.circular(8) : BorderRadius.circular(4);

  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadious,
    ),
    elevation: 4,
    fixedSize: const Size(0, 58),
  );
}
