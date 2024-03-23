import 'package:get/get.dart';

class DanXiTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'hello': '你好',
          'clicks': '点击次数：',
          'go_to_other': '去其他页面',
        },
        'en_US': {
          'hello': 'Hello',
          'clicks': 'Clicks: ',
          'go_to_other': 'Go to Other',
        },
      };
}
