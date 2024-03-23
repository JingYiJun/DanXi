import 'dart:convert';

import 'package:dan_xi/model/fdu/uis_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

abstract class SettingsItem<T> extends Rx<T?> {
  final String key;
  final T? defaultValue;

  final _storage = Get.find<FlutterSecureStorage>();

  SettingsItem(this.key, this.defaultValue) : super(defaultValue);

  T parse(String value);

  String serialize(T value) => value.toString();

  @override
  T? call([T? v]) {
    if (v != null) {
      set(v);
    }
    return get();
  }

  @nonVirtual
  T? get() {
    _storage.read(key: key).then((v) => {
          if (v != null) {value = parse(v)}
        });
    return value;
  }

  @nonVirtual
  Future<void> set(T? v) async {
    if (v == null) {
      await remove();
    } else {
      await _storage.write(key: key, value: serialize(v));
    }
    value = v;
  }

  @nonVirtual
  Future<void> remove() => _storage.delete(key: key);
}

class StringSettingsItem extends SettingsItem<String> {
  StringSettingsItem(super.key, super.defaultValue);

  @override
  String parse(String value) => value;
}

class IntSettingsItem extends SettingsItem<int> {
  IntSettingsItem(super.key, super.defaultValue);

  @override
  int parse(String value) => int.parse(value);
}

class BoolSettingsItem extends SettingsItem<bool> {
  BoolSettingsItem(super.key, super.defaultValue);

  @override
  bool parse(String value) => value == 'true';
}

class DoubleSettingsItem extends SettingsItem<double> {
  DoubleSettingsItem(super.key, super.defaultValue);

  @override
  double parse(String value) => double.parse(value);
}

class GenericSettingsItem<T> extends SettingsItem<T> {
  final T Function(String) parser;
  final String Function(T)? serializer;

  GenericSettingsItem(
    super.key,
    super.defaultValue, {
    required this.parser,
    this.serializer,
  });

  @override
  T parse(String value) => parser(value);

  @override
  String serialize(T value) => serializer?.call(value) ?? value.toString();
}

class SettingsRepository {
  final debugMode = BoolSettingsItem('debugMode', false);
  final darkMode = BoolSettingsItem('darkMode', null);
  final uisInfo = GenericSettingsItem<UISInfo>(
    'uisInfo',
    null,
    parser: (value) => UISInfo.fromJson(jsonDecode(value)),
    serializer: (value) => jsonEncode(value),
  );
}
