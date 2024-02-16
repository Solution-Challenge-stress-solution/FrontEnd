import 'package:flutter/material.dart';
import 'package:strecording/main.dart';
import 'package:strecording/widgets/webview_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyHomePage(
            email: 'test',
            name: 'test',
            profileImg: 'assets/images/profile.png')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/loginlogo.png',
              height: 160,
            ),
            const SizedBox(height: 53),
            const Text(
              'LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Dongle',
                fontSize: 65,
              ),
            ),
            const SizedBox(height: 34),
            SizedBox(
              width: 100,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  // AuthManager.signInWithGoogle(_navigateToHome);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFFFFFF)),
                  maximumSize: MaterialStateProperty.all(const Size(100, 58)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  overlayColor: MaterialStateProperty.all(
                      Colors.transparent), // Remove ripple effect
                ),
                child:
                    Image.asset('assets/images/google_login.png', height: 58),
              ),
            ),
            const SizedBox(height: 34),
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
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFFEE500)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                'assets/images/kakao_login.png',
                height: 58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
