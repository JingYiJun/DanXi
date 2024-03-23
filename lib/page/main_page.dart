import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }
}

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Scaffold(
      body: Obx(() {
        switch (controller.currentIndex) {
          case 0:
            return const Placeholder();
          case 1:
            return const Placeholder();
          default:
            return const Center(child: Text('Unknown page'));
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Business'),
        ],
        currentIndex: controller.currentIndex,
        onTap: controller.changeIndex,
      ),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Title'),

      ),
    );
  }
}