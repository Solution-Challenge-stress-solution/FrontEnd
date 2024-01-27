import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/login_platform.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:strecording/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void routeToHome(String userEmail, String userName, String? userProfileImg) {
    if (userProfileImg != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(
              email: userEmail, name: userName, profileImg: userProfileImg)));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(
              email: userEmail,
              name: userName,
              profileImg: 'assets/images/profile.png')));
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        AuthManager.currentPlatform = LoginPlatform.google;
      });

      final String email = googleUser.email;
      final String name = googleUser.displayName.toString();
      final String? profileSrc = googleUser.photoUrl;

      routeToHome(email, name, profileSrc);
    } else {
      print('google login failed!');
    }
  }

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      // get email and name
      User user = await UserApi.instance.me();
      final String userEmail = user.kakaoAccount?.email ?? '@kakao.com';
      final String userName = user.kakaoAccount?.profile?.nickname ?? 'Unknown';
      final String? userProfileimg =
          user.kakaoAccount?.profile?.thumbnailImageUrl;

      setState(() {
        AuthManager.currentPlatform = LoginPlatform.kakao;
      });

      routeToHome(userEmail, userName, userProfileimg);
    } catch (error) {
      print('failed to log in with KakaoTalk: $error');
    }
  }

  void signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken =
          result.accessToken!; // Send this token to the backend server

      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email",
      );
      final String userName = userData['name'];
      final String userEmail = userData['email'];

      setState(() {
        AuthManager.currentPlatform = LoginPlatform.facebook;
      });

      routeToHome(userEmail, userName, null);
    } else {
      print('facebook login failed!');
    }
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
                signInWithKakao();
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
