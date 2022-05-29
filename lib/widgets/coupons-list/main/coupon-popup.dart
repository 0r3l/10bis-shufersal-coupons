import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../views/loading.dart';

showCouponPopup(
  String filename,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _buildCouponWithImage(filename);
    },
  );
}

Widget _buildCouponWithImage(String filename) {
  final storage = FirebaseStorage.instance;
  return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          throw snapshot.error!;
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildPopupDialog(context, snapshot.data,
              filename.substring(0, filename.lastIndexOf('.')));
        }
        return Loading();
      },
      future: storage.ref().child(filename).getDownloadURL());
}

Widget _buildPopupDialog(BuildContext context, String imageUrl, String title) {
  return AlertDialog(
    title: Directionality(textDirection: TextDirection.rtl, child: Text(title)),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child:
                // Text(imageUrl),
                InteractiveViewer(
                    boundaryMargin: EdgeInsets.zero,
                    minScale: 0.1,
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                    )))
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
