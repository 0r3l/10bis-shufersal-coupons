import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/services/firestore.service.dart';
import 'package:tenbis_shufersal_coupons/types/get-family-group.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:tenbis_shufersal_coupons/widgets/coupons-list/deleted/deleted-coupon-list-container.dart';
import 'package:tenbis_shufersal_coupons/widgets/coupons-list/main/main-coupons-list.dart';
import '../fetch-coupons-list.dart';

class MainShoppingListContainer extends StatefulWidget {
  MainShoppingListContainer({
    Key? key,
    required this.getFamilyGroup,
    required this.list,
  }) : super(key: key);

  final GetFamilyGroup getFamilyGroup;
  final String list;

  // The framework calls createState the first time
  // a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.

  @override
  _MainShoppingListContainerState createState() =>
      _MainShoppingListContainerState();
}

class _MainShoppingListContainerState extends State<MainShoppingListContainer> {
  List<Coupon> _items = [];

  get collection {
    return '${FirestoreCollections.families}/${widget.getFamilyGroup().id}/${widget.list}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(children: [
          Expanded(
              child: FetchCouponsList(
            emptyShoppingListDescription: 'הוספת מוצרים ע״י תיבת החיפוש למעלה',
            shoppingList: () => MainCouponsList(
                items: this._items,
                collection: collection,
                familyGroup: widget.getFamilyGroup()),
            collection: collection,
            familyGroup: widget.getFamilyGroup(),
            onFetch: (items) => this._items = items,
          )),
          TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeletedShoppingListContainer(
                          originalItems: this._items,
                          familyGroup: widget.getFamilyGroup(),
                          collection: '$collection-deleted'))),
              child: Text('נמחקו לאחרונה'))
        ]));
  }
}
