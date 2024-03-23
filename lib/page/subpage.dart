import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

abstract class Subpage<T> extends GetView<T> {
  const Subpage({super.key});

  String get title;

  IconData get icon;

  PlatformIconButton? get leading => null;

  List<PlatformIconButton> get trailing => [];
}