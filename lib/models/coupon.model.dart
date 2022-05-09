import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  Coupon({required this.name, required this.id});

  String name;
  String id;
  Timestamp? deletedAt;

  factory Coupon.fromJson(Map<String, dynamic> json, String id) {
    return Coupon(name: json["name"], id: id);
  }

  Map<String, dynamic> toJson() => {'name': name, 'deletedAt': deletedAt};
}
