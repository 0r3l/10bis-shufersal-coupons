class Coupon {
  Coupon({required this.name, required this.id, required this.photoUrl});

  String name;
  String id;
  String photoUrl;

  factory Coupon.fromJson(Map<String, dynamic> json, String id) {
    return Coupon(name: json["name"], photoUrl: json["photoUrl"], id: id);
  }
}
