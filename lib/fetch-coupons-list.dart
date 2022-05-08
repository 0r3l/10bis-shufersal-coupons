import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';

class FetchCouponsList extends StatelessWidget {
  FetchCouponsList(
      {Key? key,
      required this.collection,
      required this.list,
      required this.onFetch,
      required this.emptyShoppingListDescription});

  final String collection;
  final dynamic list;
  final String emptyShoppingListDescription;
  final Function(List<dynamic>) onFetch;

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
    List<dynamic> items = snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Coupon.fromJson(data, document.id);
    }).toList();

    onFetch(items);

    return items.length == 0 ? Text('אין קופונים') : list();
  }

  static Widget errorText() => Text('משהו השתבש');
}
