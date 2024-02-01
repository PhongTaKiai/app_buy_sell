import 'package:app_buy_sell/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_model.g.dart';

@JsonSerializable()
class AppModel {
  String name;
  String description;
  String iconUrl;
  String? iosId;
  String? androidId;
  String id;

  @JsonKey(defaultValue: 0)
  double price;

  @JsonKey(
    fromJson: Utils.fromTimestamp,
    toJson: Utils.toTimestamp,
  )
  DateTime? createdAt;

  @JsonKey(defaultValue: [])
  List<String> banner = [];

  AppModel(this.name, this.description, this.iconUrl, this.price, this.id);

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppModelToJson(this);

  String get priceText {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'ja',
    );
    return formatter.format(price);
  }
}
