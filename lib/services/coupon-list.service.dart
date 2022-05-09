import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:tenbis_shufersal_coupons/models/update-coupon-list.dart';
import 'firestore.service.dart';

class ShoppingListService {
  static addProduct(UpdateShoppingList params, Coupon c) async {
    final existingProduct = params.items.where((item) => item.name == c.name);
    if (existingProduct.length == 0) {
      await FirebaseFirestore.instance
          .collection(params.collection)
          .add(c.toJson());
    }
  }
}
