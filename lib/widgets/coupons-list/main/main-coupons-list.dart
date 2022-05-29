import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
    initializeDateFormatting();
    return groupedList();
  }

  Widget groupedList() {
    return GroupedListView<dynamic, String>(
        elements: items,
        groupBy: (element) => element.name.split('.')[1],
        groupComparator: (s1, s2) {
          return int.parse(s2) - int.parse(s1);
        },
        itemComparator: (s1, s2) {
          Coupon c1 = s1;
          Coupon c2 = s2;
          extractDay(String name) => int.parse(name.split('.')[0]);

          return extractDay(c2.name) - extractDay(c1.name);
        },
        groupSeparatorBuilder: (String groupId) => Text(
              DateFormat("MMMM", 'he')
                  .format(new DateTime.utc(2022, int.parse(groupId), 1)),
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
        children: [Text(item.name.substring(0, item.name.length - 4))],
      ),
      onTap: () {
        showCouponPopup(item.name, context);
      },
    );
  }
}
