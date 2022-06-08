import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/coupon.model.dart';
import '../../../views/loading.dart';

showCouponPopup(
  Coupon coupon,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _buildCouponWithImage(coupon);
    },
  );
}

Widget _buildCouponWithImage(Coupon c) {
  final storage = FirebaseStorage.instance;
  return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          throw snapshot.error!;
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildPopupDialog(context, snapshot.data, c);
        }
        return Loading();
      },
      future: storage.ref().child(c.name).getDownloadURL());
}

Widget _buildPopupDialog(BuildContext context, String imageUrl, Coupon c) {
  return AlertDialog(
    title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(c.name.substring(0, c.name.lastIndexOf('.')))),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: InteractiveViewer(
                boundaryMargin: EdgeInsets.zero,
                minScale: 0.1,
                maxScale: 2,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                ))),
        Center(child: Text(c.barcodeNumber)),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Directionality(
            textDirection: TextDirection.rtl, child: Text('סגור')),
      ),
    ],
  );
}
