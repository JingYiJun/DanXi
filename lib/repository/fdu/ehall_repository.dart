import 'package:dan_xi/model/fdu/uis_info.dart';
import 'package:dan_xi/repository/base_repository.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'base_fdu_repository.dart';

class EhallRepository extends BaseFDURepository {
  @override
  String get host => 'ehall.fudan.edu.cn';

  @override
  String get loginUrl =>
      'https://uis.fudan.edu.cn/authserver/login?service=http%3A%2F%2Fehall.fudan.edu.cn%2Flogin%3Fservice%3Dhttp%3A%2F%2Fehall.fudan.edu.cn%2Fywtb-portal%2Ffudan%2Findex.html';

  Future<StudentInfo> getStudentInfo(UISInfo info) async {
    final jar = await BaseFDURepository.loginUIS(loginUrl, info);
    final tmpDio = BaseRepository.createTmpDio()
      ..interceptors.add(CookieManager(jar))
      ..options.followRedirects = false
      ..options.validateStatus =
          (status) => status != null && status >= 200 && status < 400;
    final res = await tmpDio.get(
        'https://ehall.fudan.edu.cn/jsonp/ywtb/info/getUserInfoAndSchoolInfo.json');
    final rawJson = res.data as Map<String, dynamic>;
    if (rawJson['data']['userName'] == null) {
      throw GeneralLoginFailedException();
    }
    return StudentInfo(rawJson['data']['userName'], rawJson['data']['userTypeName'],
        rawJson['data']['userDepartment']);
  }
}

class StudentInfo {
  final String name;
  final String? userTypeName;
  final String? userDepartment;

  StudentInfo(this.name, this.userTypeName, this.userDepartment);
}
