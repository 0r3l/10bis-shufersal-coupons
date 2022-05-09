import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tenbis_shufersal_coupons/models/coupon.model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CouponsList extends StatelessWidget {
  CouponsList({Key? key, required this.items}) : super(key: key);

  final List<Coupon> items;
  final storage = FirebaseStorage.instance;

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
          return listTile(context, item);
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
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => FutureBuilder(
                future: storage.ref().child('05.04.2022.png').getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    throw snapshot.error!;
                  }
                  // Once complete, show your application
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildPopupDialog(context, snapshot.data as String);
                  }
                  return Text('טוען...');
                }));
      },
    );
  }

  Widget _buildPopupDialog(BuildContext context, String imageUrl) {
    return AlertDialog(
      title: Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
          CachedNetworkImage(imageUrl: imageUrl)
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
