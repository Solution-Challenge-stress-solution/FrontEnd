import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:strecording/utilities/token_manager.dart' as token_manager;

enum LoginPlatform {
  google,
  kakao,
  none, // logout
}

typedef NavigationCallback = void Function();

// Utility class to manage sign-in instances and sign-out logic
class AuthManager {
  static LoginPlatform currentPlatform = LoginPlatform.none;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  // static final _kakaoUserApi = UserApi.instance;

  static Future<void> signInWithGoogle(
      NavigationCallback navigateToHome) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Get the access token from the googleAuth object
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;

      final requestUrl =
          'http://strecording.shop:8080/auth/google/access?accessToken=${accessToken}';
      final res = await http.get(Uri.parse(requestUrl));
      final resJson = json.decode(res.body);

      // Set jwt token
      if (resJson['status'] == 'SUCCESS') {
        String accessToken = resJson['data']['accessToken'];
        token_manager.TokenManager.setToken(accessToken);
        AuthManager.currentPlatform = LoginPlatform.google;
        navigateToHome();
      } else {
        print('Google login failed! Error ${resJson['status']}');
      }
    }
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

  static Future<bool> signOut() async {
    try {
      if (currentPlatform == LoginPlatform.google) {
        await signOutFromGoogle();
      }

      token_manager.TokenManager.clearToken();
      currentPlatform = LoginPlatform.none;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
