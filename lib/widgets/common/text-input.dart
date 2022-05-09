import 'package:flutter/material.dart';

class GissTextInput extends StatefulWidget {
  const GissTextInput(
      {Key? key,
      this.keyboardType,
      this.text,
      required this.onValueChanged,
      required this.hintText});

  final TextInputType? keyboardType;
  final ValueChanged<String> onValueChanged;
  final String hintText;
  final String? text;

  @override
  _GissTextInputState createState() => _GissTextInputState();
}

class _GissTextInputState extends State<GissTextInput> {
  var controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.text != null) {
      this.controller.text = widget.text!;
    }
    controller.addListener(() {
      widget.onValueChanged(controller.text);
    });
    return Flexible(
      child: TextField(
        keyboardType: widget.keyboardType ?? TextInputType.text,
        controller: controller,
        decoration: InputDecoration(hintText: widget.hintText),
      ),
    );
  }
}
