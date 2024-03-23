import 'package:dan_xi/repository/memory_cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseRepository {
  /// The host that the implementation works with.
  ///
  /// Should not contain scheme and/or path. e.g. www.jwc.fudan.edu.cn
  String get host;

  Dio? _dio;
  MemoryCookieJar? _cookieJar;

  @protected
  Dio get dio {
    if (_dio == null) {
      if (_dios.containsKey(host)) {
        _dio = _dios[host]!;
      } else {
        _dio = _dios[host] = createDio();
      }
    }
    return _dio!;
  }

  @protected
  MemoryCookieJar get cookieJar {
    if (_cookieJar == null) {
      if (_cookieJars.containsKey(host)) {
        _cookieJar = _cookieJars[host]!;
      } else {
        _cookieJar = _cookieJars[host] = createCookieJar();
      }
    }
    return _cookieJar!;
  }

  @protected
  Dio createDio() => createTmpDio()
    ..interceptors.add(CookieManager(cookieJar));

  static Dio createTmpDio() => Dio()
    ..options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    );

  @protected
  MemoryCookieJar createCookieJar() => MemoryCookieJar();

  static final Map<String, Dio> _dios = {};
  static final Map<String, MemoryCookieJar> _cookieJars = {};
}
