import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/token_manager.dart' as token_manager;

enum LoginPlatform {
  google,
  kakao,
  facebook,
  none, // logout
}

typedef NavigationCallback = void Function();

// Utility class to manage sign-in instances and sign-out logic
class AuthManager {
  static LoginPlatform currentPlatform = LoginPlatform.none;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final _kakaoUserApi = UserApi.instance;

  static Future<void> signInWithGoogle(
      NavigationCallback navigateToHome) async {
    // final signinUrlRes =
    //     await http.get(Uri.parse('http://34.64.90.112:8080/auth/google'));
    //     json.decode(signinUrlRes)[]
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      AuthManager.currentPlatform = LoginPlatform.google;

      final String email = googleUser.email;
      final String name = googleUser.displayName.toString();
      final String? profileSrc = googleUser.photoUrl;

      //navigateToHome(email, name, profileSrc);
    } else {
      print('google login failed!');
    }
  }

  static Future<String> getGoogleUrl() async {
    String requestUrl = 'http://34.64.90.112:8080/auth/google';
    final response = await http.get(Uri.parse(requestUrl));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<void> signInWithKakao(String oauthCode) async {
    try {
      String requestUrl =
          'http://34.64.90.112:8080/auth/kakao?code=${oauthCode}';
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody['status'] == 'SUCCESS' &&
            responseBody.containsKey('data')) {
          String accessToken = responseBody['data']['accessToken'];
          token_manager.TokenManager.setToken(accessToken);
          AuthManager.currentPlatform = LoginPlatform.kakao;
        } else {
          print('Login failed: ${responseBody['message']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Failed to log in with Kakao: $error');
    }
  }

  static Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  static Future<void> signOutFromKakao() async {
    await _kakaoUserApi.logout();
  }

  static Future<bool> signOut() async {
    try {
      switch (currentPlatform) {
        case LoginPlatform.google:
          await signOutFromGoogle();
          break;
        case LoginPlatform.kakao:
          await signOutFromKakao();
          break;
        case LoginPlatform.none:
        default:
          break;
      }
      currentPlatform = LoginPlatform.none;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
