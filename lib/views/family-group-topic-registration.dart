import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/views/loading.dart';

import 'home.dart';

class FamilyGroupTopicRegistration extends StatefulWidget {
  const FamilyGroupTopicRegistration(
      {Key? key, required this.familyGroup, required this.onUserChanged})
      : super(key: key);
  final FamilyGroup familyGroup;
  final Function(User?) onUserChanged;

  @override
  _FamilyGroupTopicRegistrationState createState() =>
      _FamilyGroupTopicRegistrationState();
}

class _FamilyGroupTopicRegistrationState
    extends State<FamilyGroupTopicRegistration> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Home(
          familyGroup: widget.familyGroup, onUserChanged: widget.onUserChanged);
    }
    return FutureBuilder(
        future:
            FirebaseMessaging.instance.subscribeToTopic(widget.familyGroup.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Home(
                familyGroup: widget.familyGroup,
                onUserChanged: widget.onUserChanged);
          }
          return Loading();
        });
  }
}
