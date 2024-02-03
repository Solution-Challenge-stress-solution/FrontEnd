import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

enum LoginPlatform {
  google,
  kakao,
  facebook,
  none, // logout
}

typedef NavigationCallback = void Function(
    String email, String name, String? profileImg);

// Utility class to manage sign-in instances and sign-out logic
class AuthManager {
  static LoginPlatform currentPlatform = LoginPlatform.none;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final _kakaoUserApi = UserApi.instance;
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

  static Future<void> signInWithGoogle(
      NavigationCallback navigateToHome) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      AuthManager.currentPlatform = LoginPlatform.google;

      final String email = googleUser.email;
      final String name = googleUser.displayName.toString();
      final String? profileSrc = googleUser.photoUrl;

      navigateToHome(email, name, profileSrc);
    } else {
      print('google login failed!');
    }
  }

  static Future<void> signInWithKakao(NavigationCallback navigateToHome) async {
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

      // // 백엔드 jwt 토큰 추가
      // // 카카오 로그인 후 OAuth 토큰을 서버로 전송
      // final jwtTokenResponse = await http.post(
      //   Uri.parse('YOUR_BACKEND_ENDPOINT'), // 백엔드 JWT 토큰 교환 엔드포인트
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, String>{
      //     'kakaoAccessToken': token.accessToken, // 카카오 액세스 토큰
      //   }),
      // );

      // if (jwtTokenResponse.statusCode == 200) {
      //   // 성공적으로 JWT 토큰을 받았을 때의 처리
      //   String jwtToken =
      //       json.decode(jwtTokenResponse.body)['jwtToken']; // JWT 토큰 파싱
      //   // JWT 토큰을 이용한 추가 로직 구현
      // } else {
      //   // 서버로부터 JWT 토큰을 받는 데 실패했을 때의 처리
      //   print('Failed to load data: ${response.statusCode}');
      //   print('Error message: ${response.body}');
      // }

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      // Get email and name
      User user = await UserApi.instance.me();
      final String userEmail = user.kakaoAccount?.email ?? '@kakao.com';
      final String userName = user.kakaoAccount?.profile?.nickname ?? 'Unknown';
      final String? userProfileimg =
          user.kakaoAccount?.profile?.thumbnailImageUrl;

      AuthManager.currentPlatform = LoginPlatform.kakao;

      navigateToHome(userEmail, userName, userProfileimg);
    } catch (error) {
      print('failed to log in with KakaoTalk: $error');
    }
  }

  static Future<void> signInWithFacebook(
      NavigationCallback navigateToHome) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken =
          result.accessToken!; // Send this token to the backend server

      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email",
      );
      final String userName = userData['name'];
      final String userEmail = userData['email'];

      AuthManager.currentPlatform = LoginPlatform.facebook;

      navigateToHome(userEmail, userName, null);
    } else {
      print('facebook login failed!');
    }
  }

  static Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  static Future<void> signOutFromFacebook() async {
    await _facebookAuth.logOut();
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
        case LoginPlatform.facebook:
          await signOutFromFacebook();
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
