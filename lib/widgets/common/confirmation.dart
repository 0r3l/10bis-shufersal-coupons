import 'package:flutter/material.dart';

class Confirmation {
  Confirmation({required this.title, required this.onPress, this.content});

  final String title;
  final Widget? content;
  final Function onPress;

  Future<AlertDialog?> show(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("ביטול"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text("אישור"),
      onPressed: () {
        onPress();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    final alert = Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(title),
          content: content ?? Text(''),
          actions: [
            cancelButton,
            continueButton,
          ],
        ));
    // show the dialog
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
