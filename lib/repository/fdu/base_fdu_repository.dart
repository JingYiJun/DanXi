import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dan_xi/model/fdu/uis_info.dart';
import 'package:dan_xi/repository/base_repository.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:synchronized/synchronized.dart';



abstract class BaseFDURepository extends BaseRepository {
  String get loginUrl;

  static const String UIS_HOST = 'uis.fudan.edu.cn';
  static const String _CAPTCHA_CODE_NEEDED = '请输入验证码';
  static const String _CREDENTIALS_INVALID = '密码有误';
  static const String _WEAK_PASSWORD = '弱密码提示';
  static const String _UNDER_MAINTENANCE = '网络维护中 | Under Maintenance';

  static final _loginLock = Lock();

  Future<Response<T>> withUIS<T>(FutureOr<Response<T>> Function() function) async {
    final res = await function();
    if (res.realUri.host.contains(UIS_HOST)) {
      cookieJar.replaceBy(await loginUIS(loginUrl, UISInfo('123', '456')));
      return function();
    }
    return res;
  }

  static Future<CookieJar> loginUIS(String url, UISInfo info) async => _loginLock.synchronized(() async {
    final workJar = CookieJar();
    final workDio = BaseRepository.createTmpDio()
      ..interceptors.add(CookieManager(workJar))
      ..options.followRedirects = false
      ..options.validateStatus =
          (status) => status != null && status >= 200 && status < 400;

    Response<String> res = await workDio.get(url);
    final data = <String, String>{};
    final doc = parse(res.data!);
    doc.querySelectorAll('input').forEach((element) {
      if (element.attributes['type'] != 'button') {
        data[element.attributes['name']!] = element.attributes['value']!;
      }
    });
    data['username'] = info.id;
    data['password'] = info.password;
    res = await workDio.post(url, data: data);

    // process redirect
    while (res.statusCode == 302) {
      final location = res.headers.value(HttpHeaders.locationHeader);
      if (location == null || location.isEmpty) {
        break;
      }
      res = await workDio.get(location);
    }

    final body = res.data ?? '';
    if (body.contains(_CAPTCHA_CODE_NEEDED)) {
      throw CaptchaNeededException();
    } else if (body.contains(_CREDENTIALS_INVALID)) {
      throw CredentialsInvalidException();
    } else if (body.contains(_UNDER_MAINTENANCE)) {
      throw NetworkMaintenanceException();
    } else if (body.contains(_WEAK_PASSWORD)) {
      throw GeneralLoginFailedException();
    }

    return workJar;
  });
}

sealed class UISLoginException implements Exception {}

class CaptchaNeededException extends UISLoginException {}
class CredentialsInvalidException extends UISLoginException {}
class NetworkMaintenanceException extends UISLoginException {}
class GeneralLoginFailedException extends UISLoginException {}