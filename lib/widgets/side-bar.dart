import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/types/get-family-group.dart';
import 'package:tenbis_shufersal_coupons/views/family-group-qr-view.dart';
import 'package:tenbis_shufersal_coupons/views/family-select.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Sidebar extends StatefulWidget {
  Sidebar(
      {Key? key,
      required this.user,
      required this.getFamilyGroup,
      required this.onGroupFamilyChanged,
      required this.onUserLogout})
      : super(key: key);

  final User? user;
  final Function onUserLogout;
  final ValueChanged<FamilyGroup> onGroupFamilyChanged;
  final GetFamilyGroup getFamilyGroup;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  FamilyGroup? _familyGroup;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.orange,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Column(children: [
                  Text(
                    '10BC',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  Text('קופוני תן ביס',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Divider(),
                  Text('שלום ${widget.user!.displayName}',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text(_familyGroup?.name ?? widget.getFamilyGroup().name)
                ])),
            Divider(),
            ListTile(
                enabled: true,
                title: Text('בחירת קבוצת משפחה '),
                leading: Icon(Icons.group),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FamilySelect(
                                onFamilySelectCompleted:
                                    (FamilyGroup familyGroup) {
                              widget.onGroupFamilyChanged(familyGroup);
                              setState(() {
                                _familyGroup = familyGroup;
                              });
                            })))),
            ListTile(
                enabled: true,
                title: Text('צרוף חבר לקבוצת המשפחה'),
                leading: Icon(Icons.qr_code_2),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FamilyGroupQrView(
                              familyGroup: widget.getFamilyGroup(),
                            )))),
            ListTile(
              title: Text('התנתק'),
              leading: Icon(Icons.logout),
              onTap: () async {
                EasyLoading.show(status: '...יוצא');
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                EasyLoading.dismiss();
                widget.onUserLogout();
              },
            )
          ],
        ));
  }
}
