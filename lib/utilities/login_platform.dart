import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

enum LoginPlatform {
  google,
  kakao,
  facebook,
  none, // logout
}

// Utility class to manage sign-in instances and sign-out logic
class AuthManager {
  static LoginPlatform currentPlatform = LoginPlatform.none;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final _kakaoUserApi = UserApi.instance;
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

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
