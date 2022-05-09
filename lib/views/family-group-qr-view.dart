import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FamilyGroupQrView extends StatelessWidget {
  const FamilyGroupQrView({Key? key, required this.familyGroup})
      : super(key: key);

  final FamilyGroup familyGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('צרוף חבר לקבוצת משפחה')),
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('סרקו את הקוד באפליקציה של המכשיר השני'),
                          Text('כדי לצרף לקבוצת ${familyGroup.name}'),
                          Text('במכשיר השני היכנסו לאפליקציה בתפריט הראשי'),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('בחירת קבוצת משפחה'),
                              Icon(Icons.arrow_downward),
                              Text('הצטרפות לקבוצת משפחה קיימת')
                            ],
                          )
                        ]),
                    CachedNetworkImage(
                      imageUrl:
                          'https://chart.googleapis.com/chart?cht=qr&chl=${this.familyGroup.id}&chld=L|1&choe=UTF-8&chs=300x300',
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ],
                ))));
  }
}
