import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/blocs/list_block.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';
import 'package:tenbis_shufersal_coupons/services/firestore.service.dart';
import 'package:tenbis_shufersal_coupons/widgets/common/confirmation.dart';
import 'package:tenbis_shufersal_coupons/widgets/coupons-list/main/main-coupons-list-container.dart';
import 'package:tenbis_shufersal_coupons/widgets/side-bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.familyGroup, required this.onUserChanged})
      : super(key: key);
  final FamilyGroup familyGroup;
  final ValueChanged<User?> onUserChanged;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState() {
    _user = FirebaseAuth.instance.currentUser;
  }

  User? _user;

  FamilyGroup? _familyGroup;

  onGroupFamilyChanged(FamilyGroup familyGroup) {
    _familyGroup = familyGroup;
    Confirmation(
        title: 'קבוצת משפחה השתנתה',
        content: Text('הועברת לקבוצה ${familyGroup.name}'),
        onPress: () => Navigator.pop(context)).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.getList,
        initialData:
            ListItem(id: FirestoreCollections.coupons, name: 'קופוני שופרסל'),
        builder: (context, snapshot) => Scaffold(
            backgroundColor: Color(0xFFEFEFEF),
            appBar: header((snapshot.data as ListItem).name),
            drawer: Sidebar(
                onGroupFamilyChanged: onGroupFamilyChanged,
                user: _user,
                getFamilyGroup: () => _familyGroup ?? widget.familyGroup,
                onUserLogout: () => widget.onUserChanged(null)),
            body: MainShoppingListContainer(
              list: (snapshot.data as ListItem).id,
              getFamilyGroup: () => _familyGroup ?? widget.familyGroup,
            )));
  }

  PreferredSizeWidget header(String title) => AppBar(
        backgroundColor: Colors.orange,
        actions: [
          Tab(
            icon: Container(
              child: CachedNetworkImage(
                  key: Key(FirebaseAuth.instance.currentUser!.photoURL!),
                  imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
              width: 40,
              margin: EdgeInsets.all(3),
            ),
          )
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Center(child: Text(title))],
        ),
      );
}
