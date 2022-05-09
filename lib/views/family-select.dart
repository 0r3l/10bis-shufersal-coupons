import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/services/firestore.service.dart';
import 'package:tenbis_shufersal_coupons/views/loading.dart';
import 'package:tenbis_shufersal_coupons/widgets/common/qr-view.dart';
import 'package:tenbis_shufersal_coupons/widgets/common/text-input-with-button.dart';

class FamilySelect extends StatefulWidget {
  const FamilySelect({Key? key, required this.onFamilySelectCompleted})
      : super(key: key);
  final ValueChanged<FamilyGroup> onFamilySelectCompleted;

  @override
  _FamilySelectState createState() => _FamilySelectState();
}

class _FamilySelectState extends State<FamilySelect> {
  _FamilySelectState() {
    _user = FirebaseAuth.instance.currentUser;
  }
  String? _groupName;
  User? _user;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('בחירת קבוצת משפחה')),
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: _isLoading
                ? Loading()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: GissTextInputWithButton(
                            hintText: 'הכנס שם קבוצה',
                            onValueChanged: (value) => _groupName = value,
                            onButtonClickedCallback: () async {
                              if (_groupName != null && _groupName != '') {
                                EasyLoading.show(
                                    status: '...יצירת קבוצה בתהליך');
                                final familyGroup = await createFamilyGroup();
                                widget.onFamilySelectCompleted(familyGroup);
                                EasyLoading.dismiss();
                              }
                            },
                          )),
                      Text('או'),
                      Divider(),
                      TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('הצטרפות לקבוצת משפחה קיימת'),
                            Icon(Icons.qr_code)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GissQRView(
                                          onScanCompleted: (String code) async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await attachFamilyGroup(code);
                                      })));
                        },
                      ),
                    ],
                  )));
  }

  Future createFamilyGroup() async {
    // create family
    final familyDoc =
        await FirestoreService.add('families', {"name": _groupName});
    final familyGroup = FamilyGroup(id: familyDoc.id, name: _groupName!);
    await updateFamilyGroup(familyGroup);
    return familyGroup;
  }

  attachFamilyGroup(String id) async {
    final doc =
        await FirestoreService.getById(FirestoreCollections.families, id);
    if (doc != null) {
      final familyGroup = FamilyGroup(id: id, name: doc["name"]);
      await updateFamilyGroup(familyGroup);
      Navigator.pop(context);
      widget.onFamilySelectCompleted(familyGroup);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'ברקוד לא תקין',
        textDirection: TextDirection.rtl,
      )));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future updateFamilyGroup(FamilyGroup familyGroup) async {
    // remove all user occurrences if exist from familyUser collection
    // final familyUserDocs = await FirestoreService.findDocs(
    //     Collection.FAMILY_USERS, 'userId', _user!.uid);

    // if (familyUserDocs != null) {
    await FirestoreService.batchDeleteQueryDocuments(
        FirestoreCollections.familyUsers, 'userId', _user!.uid);
    // }

    // add user to familyUser collection
    await FirestoreService.add('familyUsers', {
      "familyId": familyGroup.id,
      "userId": _user!.uid,
      "familyName": familyGroup.name
    });
  }
}
