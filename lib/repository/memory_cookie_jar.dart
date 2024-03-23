import 'package:cookie_jar/cookie_jar.dart';

/// A wrapper of a [CookieJar] that can easily change inner implementation
class MemoryCookieJar implements CookieJar {
  CookieJar _jar;

  @override
  final bool ignoreExpires;

  MemoryCookieJar({
    CookieJar? jar,
    this.ignoreExpires = false,
  }) : _jar = jar ?? CookieJar();

  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) =>
      _jar.delete(uri, withDomainSharedCookie);

  @override
  Future<void> deleteAll() => _jar.deleteAll();

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) => _jar.loadForRequest(uri);

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) =>
      _jar.saveFromResponse(uri, cookies);

  /// replace inner jar by [jar]
  void replaceBy(CookieJar jar) {
    _jar = jar;
  }
}
