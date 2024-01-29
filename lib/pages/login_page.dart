import 'package:flutter/material.dart';
import 'package:strecording/main.dart';
import 'package:strecording/utilities/login_platform.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _navigateToHome(String email, String name, String? profileImg) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyHomePage(
            email: email,
            name: name,
            profileImg: profileImg ?? 'assets/images/profile.png')));
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
                  AuthManager.signInWithGoogle(_navigateToHome);
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
                AuthManager.signInWithKakao(_navigateToHome);
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
            const SizedBox(height: 34),
            SizedBox(
              width: 200,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  AuthManager.signInWithFacebook(_navigateToHome);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF316FF6)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text('Sign in with Facebook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
