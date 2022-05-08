import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';

class CouponsList extends StatelessWidget {
  CouponsList({Key? key, required this.items}) : super(key: key);

  final List<Coupon> items;

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
              style: TextStyle(
                  color: Colors.blueAccent.shade400,
                  fontWeight: FontWeight.bold),
            ),
        itemBuilder: (context, item) {
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item.id!),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
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

  Widget listTile(BuildContext context, dynamic item) {
    return ListTile(
      leading: CachedNetworkImage(
          key: Key(item.photoUrl!),
          imageUrl: item.photoUrl!,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.image)),
      title: Wrap(
        children: [Text(item.name)],
      ),
      onTap: () {},
    );
  }
}
