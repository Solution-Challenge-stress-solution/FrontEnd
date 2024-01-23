import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:strecording/login_platform.dart';
import 'package:strecording/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void routeToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'STREcording')));
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });

      routeToHome();
    } else {
      print('google login failed!');
    }
  }

  void signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      // Send the token to the backend server

      setState(() {
        _loginPlatform = LoginPlatform.facebook;
      });

      routeToHome();
    } else {
      print('facebook login failed!');
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.facebook:
        await FacebookAuth.instance.logOut();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
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
                  // Implement Google Sign-In
                  signInWithGoogle();
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
                // Implement Kakao Sign-In
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
                  // Implement Facebook Sign-In
                  signInWithFacebook();
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
