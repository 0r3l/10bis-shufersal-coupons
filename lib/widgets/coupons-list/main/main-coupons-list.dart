import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:tenbis_shufersal_coupons/services/firestore.service.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tenbis_shufersal_coupons/widgets/coupons-list/main/coupon-popup.dart';

class MainCouponsList extends StatelessWidget {
  MainCouponsList(
      {Key? key,
      required this.items,
      required this.familyGroup,
      required this.collection})
      : super(key: key);

  final List<Coupon> items;
  final FamilyGroup familyGroup;
  final String collection;

  @override
  Widget build(BuildContext context) {
    return groupedList();
  }

  Widget groupedList() {
    return GroupedListView<dynamic, String>(
        elements: items,
        groupBy: (element) => element.toString(),
        groupComparator: (String s1, String s2) {
          return int.parse(s1) - int.parse(s2);
        },
        groupSeparatorBuilder: (String groupId) => Text(
              'ללא סיווג',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
        itemBuilder: (context, item) {
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item.id!),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) async {
              await FirestoreService.archive(collection, familyGroup, item.id);
            },
            // Show a red background as the item is swiped away.
            background: Container(
                color: Colors.red,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.delete), Icon(Icons.delete)])),
            child: listTile(context, item),
          );
        });
  }

  Widget listTile(BuildContext context, Coupon item) {
    return ListTile(
      title: Wrap(
        children: [Text(item.name)],
      ),
      onTap: () {
        showCouponPopup('${item.name}.png', context);
      },
    );
  }
}
