import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  Coupon(
      {required this.name,
      required this.id,
      required this.barcodeNumber,
      this.deletedAt});

  String name;
  String barcodeNumber;
  String id;
  Timestamp? deletedAt;

  factory Coupon.fromJson(Map<String, dynamic> json, String id) {
    return Coupon(
        name: json["name"],
        barcodeNumber: json["barcodeNumber"],
        id: id,
        deletedAt: json.keys.contains('deletedAt') ? json['deletedAt'] : null);
  }

  Map<String, dynamic> toJson() => {'name': name, 'deletedAt': deletedAt};
}
