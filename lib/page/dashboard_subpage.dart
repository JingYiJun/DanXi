import 'package:dan_xi/page/subpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var count = 0.obs;

  increment() => count++;
}

class DashboardSubpage extends Subpage<DashboardController> {
  const DashboardSubpage({super.key});

  @override
  String get title => 'dashboard'.tr;

  @override
  IconData get icon => isMaterial(Get.context!)
      ? Icons.dashboard
      : CupertinoIcons.square_stack_3d_up_fill;

  @override
  PlatformIconButton? get leading => PlatformIconButton(
        materialIcon: const Icon(Icons.notifications),
        cupertinoIcon: const Icon(CupertinoIcons.bell_circle),
        onPressed: () => Get.toNamed('/announcement/list'),
      );

  @override
  List<PlatformIconButton> get trailing => [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
