import 'package:dan_xi/repository/fdu/ehall_repository.dart';
import 'package:dan_xi/repository/settings/settings_repository.dart';
import 'package:dan_xi/translations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

void main() {
  init();
  runApp(const MyApp());
}

void init() {
  // settings storage
  Get.put(const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ));

  // all settings
  Get.put(SettingsRepository());

  // fdu repositories
  Get.lazyPut(() => EhallRepository());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsRepository>();
    return Obx(
      () => AnimatedFluentTheme(
        data: FluentThemeData(
          brightness: settings.darkMode() ?? false ? Brightness.dark : Brightness.light,
        ),
        child: GetMaterialApp(
          translations: DanXiTranslations(),
          locale: Get.deviceLocale ?? const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FluentLocalizations.delegate,
          ],
          home: const HomePage(),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  var count = 0.obs;

  void increment() => count++;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text("${'clicks'.tr}${c.count}"))),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.to(() => const OtherPage()),
          child: Text('go_to_other'.tr),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: c.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text("${'clicks'.tr}${c.count}"))),
      floatingActionButton: FloatingActionButton(
        onPressed: c.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
