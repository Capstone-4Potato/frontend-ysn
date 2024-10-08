import 'package:flutter_application_1/login/login_platform.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

// 소셜로그인 로그아웃하기
class SignOutService {
  static Future<void> signOut(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.google:
        // Add Google sign-out logic here
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        print('kakaologout');
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        print('naverlogout');
        break;
      case LoginPlatform.apple:
        // Add Apple sign-out logic here
        //await FlutterNaverLogin.logOut();
        //print('naverlogout');
        break;
      case LoginPlatform.none:
        break;
    }
  }
}
