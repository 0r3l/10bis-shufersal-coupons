import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';

import 'empty-coupons-list.dart';

class FetchCouponsList extends StatelessWidget {
  FetchCouponsList(
      {Key? key,
      required this.collection,
      required this.shoppingList,
      required this.familyGroup,
      required this.onFetch,
      required this.emptyShoppingListDescription});

  final String collection;
  final FamilyGroup familyGroup;
  final Function(List<Coupon>) onFetch;
  final dynamic shoppingList;
  final String emptyShoppingListDescription;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("טוען...");
          }

          return snapshot.data != null
              ? createListWidget(snapshot)
              : errorText();
        });
  }

  Widget createListWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Coupon> items = snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Coupon.fromJson(data, document.id);
    }).toList();

    onFetch(items);

    return items.length == 0
        ? EmptyCouponsList(
            description: emptyShoppingListDescription,
          )
        : shoppingList();
  }

  static Widget errorText() => Text('משהו השתבש');
}
