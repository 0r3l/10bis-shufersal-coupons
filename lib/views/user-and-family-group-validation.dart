import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/auth/signin.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/services/firestore.service.dart';
import 'package:tenbis_shufersal_coupons/views/family-group-topic-registration.dart';
import 'package:tenbis_shufersal_coupons/views/loading.dart';

import 'family-select.dart';

class UserAndFamilyGroupValidation extends StatefulWidget {
  UserAndFamilyGroupValidation({Key? key}) : super(key: key);

  @override
  _UserAndFamilyGroupValidationState createState() =>
      _UserAndFamilyGroupValidationState();
}

class _UserAndFamilyGroupValidationState
    extends State<UserAndFamilyGroupValidation> {
  _UserAndFamilyGroupValidationState() {
    _user = FirebaseAuth.instance.currentUser;
  }

  User? _user;
  FamilyGroup? _familyGroup;

  setUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? SocialSignin(
            onUserChanged: setUser,
          )
        : getFamilyGroupFirst();
  }

  getFamilyGroupFirst() => FutureBuilder(
      future: FirestoreService.findDocs(
          FirestoreCollections.familyUsers, 'userId', _user!.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // family group is missing
          if (snapshot.data == null) {
            return FamilySelect(
                onFamilySelectCompleted: (FamilyGroup familyGroup) =>
                    setUser(_user));
          } else {
            _familyGroup = FamilyGroup.fromJson(snapshot.data.first);
            return FamilyGroupTopicRegistration(
              familyGroup: _familyGroup!,
              onUserChanged: (user) => setUser(user),
            );
          }
        }
        if (snapshot.hasError) {
          return Text('שם קבוצה לא זמין');
        }
        return Loading();
      });
}
