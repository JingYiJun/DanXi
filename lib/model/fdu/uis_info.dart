import 'package:json_annotation/json_annotation.dart';

part 'uis_info.g.dart';

@JsonSerializable()
/// This class is used to store the information of FDU UIS info.
class UISInfo {
  /// [id] is user's student ID.
  /// [password] is user's password to school platform.
  /// [name] is user's real name.
  String id, password, name;

  UISInfo(this.id, this.password, [this.name = '']);

  @override
  String toString() {
    return 'UISInfo{id: $id, password: $password, name: $name}';
  }

  factory UISInfo.fromJson(Map<String, dynamic> json) => _$UISInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UISInfoToJson(this);
}