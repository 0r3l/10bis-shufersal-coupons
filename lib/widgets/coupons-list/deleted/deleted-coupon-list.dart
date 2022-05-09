import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:intl/intl.dart';
import 'package:tenbis_shufersal_coupons/widgets/common/checkbox.dart';
import 'package:grouped_list/grouped_list.dart';

class DeletedCouponList extends StatefulWidget {
  DeletedCouponList(
      {Key? key,
      required this.items,
      required this.familyGroup,
      required this.onItemsSelected,
      required this.collection})
      : super(key: key);

  final List<Coupon> items;
  final FamilyGroup familyGroup;
  final String collection;
  final Function(Map<String, Coupon>) onItemsSelected;

  @override
  _DeletedCouponListState createState() => _DeletedCouponListState();
}

class _DeletedCouponListState extends State<DeletedCouponList> {
  Map<String, Coupon> selected = new Map();
  bool isRestoreButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: GroupedListView<dynamic, String>(
                order: GroupedListOrder.DESC,
                elements: widget.items,
                groupBy: (element) =>
                    DateFormat.yMd().format(element.deletedAt.toDate()),
                groupSeparatorBuilder: (String deletedAt) => Text(
                      deletedAt,
                      style: TextStyle(
                          color: Colors.blueAccent.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                itemBuilder: (context, item) {
                  return listTile(context, item);
                })),
        isRestoreButtonVisible
            ? TextButton(
                onPressed: () => widget.onItemsSelected(selected),
                child: Text('שחזור מסומנים'))
            : Text('')
      ],
    );
  }

  Widget listTile(BuildContext context, Coupon item) {
    return ListTile(
      key: Key(item.id),
      leading: GissCheckbox(
          isChecked: selected.containsKey(item.id),
          onChecked: (isChecked) {
            isChecked
                ? selected.putIfAbsent(item.id, () => item)
                : selected.removeWhere((key, value) => key == item.id);
            setState(() {
              isRestoreButtonVisible = selected.length > 0;
            });
          }),
      title: Text(
          '${item.name} (${DateFormat.Hm().format(item.deletedAt!.toDate())})'),
    );
  }
}
