import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:tenbis_shufersal_coupons/models/update-coupon-list.dart';
import 'package:tenbis_shufersal_coupons/services/coupon-list.service.dart';

import '../fetch-coupons-list.dart';
import 'deleted-coupon-list.dart';

class DeletedShoppingListContainer extends StatefulWidget {
  DeletedShoppingListContainer(
      {Key? key,
      required this.familyGroup,
      required this.collection,
      required this.originalItems})
      : super(key: key);

  final FamilyGroup familyGroup;
  final String collection;
  final List<Coupon> originalItems;
  final Map<String, Coupon> selected = new Map();

  @override
  _DeletedShoppingListContainerState createState() =>
      _DeletedShoppingListContainerState();
}

class _DeletedShoppingListContainerState
    extends State<DeletedShoppingListContainer> {
  List<Coupon> _items = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xFFEFEFEF),
            appBar: AppBar(title: Text('נמחקו לאחרונה')),
            body: Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: FetchCouponsList(
                    emptyShoppingListDescription: 'לא נמחקו מוצרים מהרשימה',
                    shoppingList: () => DeletedCouponList(
                        items: this._items,
                        collection: widget.collection,
                        onItemsSelected: (selected) {
                          selected.forEach((id, product) async {
                            await ShoppingListService.addProduct(
                                UpdateShoppingList(
                                    collection: widget.collection.substring(
                                        0, widget.collection.lastIndexOf('-')),
                                    items: widget.originalItems,
                                    familyGroup: widget.familyGroup),
                                product);
                          });
                          Navigator.pop(context);
                        },
                        familyGroup: widget.familyGroup),
                    collection: widget.collection,
                    familyGroup: widget.familyGroup,
                    onFetch: (items) => this._items = items,
                  )),
            )));
  }
}
