class FamilyGroup {
  const FamilyGroup({required this.id, required this.name});
  final String id;
  final String name;

  factory FamilyGroup.fromJson(dynamic json) {
    return FamilyGroup(id: json['familyId'], name: json['familyName']);
  }
}
