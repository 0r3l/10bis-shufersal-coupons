import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final facebookAuthCredential =
      FacebookAuthProvider.credential(result.accessToken!.token);

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(facebookAuthCredential);
}

Future<UserCredential> signInWithGoogle() async {
  if (kIsWeb) {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class SocialSignin extends StatelessWidget {
  SocialSignin({Key? key, required this.onUserChanged}) : super(key: key);

  final ValueChanged<User?> onUserChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
          Center(
            child: SignInButton(Buttons.Google, text: "כניסה עם Google",
                onPressed: () async {
              EasyLoading.show(status: '...טוען');
              final userCredential = await signInWithGoogle().catchError((err) {
                EasyLoading.showError(err);
              });
              EasyLoading.dismiss();
              this.onUserChanged(userCredential.user);
            }),
            // SignInButton(
            //   Buttons.Facebook,
            //   text: "Sign up with Facebook",
            //   onPressed: signInWithFacebook,
            // )
          )
        ]));
  }
}
