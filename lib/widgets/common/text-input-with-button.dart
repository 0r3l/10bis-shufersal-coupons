import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/widgets/common/text-input.dart';

class GissTextInputWithButton extends StatefulWidget {
  const GissTextInputWithButton(
      {Key? key,
      required this.hintText,
      this.text,
      this.keyboardType,
      required this.onValueChanged,
      required this.onButtonClickedCallback})
      : super(key: key);

  final String hintText;
  final ValueChanged<String> onValueChanged;
  final Function onButtonClickedCallback;
  final String? text;
  final TextInputType? keyboardType;

  @override
  _GissTextInputWithButtonState createState() =>
      _GissTextInputWithButtonState();
}

class _GissTextInputWithButtonState extends State<GissTextInputWithButton> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GissTextInput(
        text: widget.text,
        onValueChanged: (String val) => widget.onValueChanged(val),
        hintText: widget.hintText,
        keyboardType: widget.keyboardType,
      ),
      Padding(padding: EdgeInsets.only(right: 10)),
      TextButton(
          onPressed: () => widget.onButtonClickedCallback(),
          child: Icon(Icons.done)),
    ]);
  }
}
