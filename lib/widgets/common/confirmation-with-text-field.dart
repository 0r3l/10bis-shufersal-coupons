import 'package:flutter/material.dart';

class ConfirmationWithTextField {
  ConfirmationWithTextField(
      {required this.title,
      this.hintText,
      required this.onConfirm,
      this.content});

  final String title;
  final String? hintText;
  final Widget? content;
  final Function onConfirm;
  String valueText = '';

  TextEditingController _textFieldController = TextEditingController();

  Future<AlertDialog?> show(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("ביטול"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text("אישור"),
      onPressed: () {
        onConfirm(valueText);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    final alert = Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              valueText = value;
            },
            decoration: InputDecoration(hintText: hintText),
            controller: _textFieldController,
          ),
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
