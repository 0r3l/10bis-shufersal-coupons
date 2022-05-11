import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  Coupon({required this.name, required this.id, this.deletedAt});

  String name;
  String id;
  Timestamp? deletedAt;

  factory Coupon.fromJson(Map<String, dynamic> json, String id) {
    return Coupon(
        name: json["name"],
        id: id,
        deletedAt: json.keys.contains('deletedAt') ? json['deletedAt'] : null);
  }

  Map<String, dynamic> toJson() => {'name': name, 'deletedAt': deletedAt};
}
