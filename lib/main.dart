import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:tenbis_shufersal_coupons/blocs/int_block.dart';
import 'package:tenbis_shufersal_coupons/views/user-and-family-group-validation.dart';
import 'package:tenbis_shufersal_coupons/views/loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'blocs/list_block.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          throw snapshot.error!;
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'קופני תן ביס שופרסל',
              theme:
                  ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
              builder: EasyLoading.init(),
              home: Directionality(
                  textDirection: TextDirection.rtl,
                  child: UserAndFamilyGroupValidation()));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    intBloc.dispose();
    super.dispose();
  }
}
