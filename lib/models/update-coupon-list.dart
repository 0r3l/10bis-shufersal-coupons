import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';

import 'family-group.dart';

class UpdateShoppingList {
  const UpdateShoppingList(
      {required this.collection,
      required this.items,
      required this.familyGroup});

  final String collection;
  final FamilyGroup familyGroup;
  final List<Coupon> items;
}
