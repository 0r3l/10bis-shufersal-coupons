import 'package:flutter/material.dart';

class GissCheckbox extends StatefulWidget {
  const GissCheckbox(
      {Key? key, required this.onChecked, required this.isChecked})
      : super(key: key);
  final ValueChanged onChecked;
  final bool isChecked;

  @override
  _GissCheckboxState createState() => _GissCheckboxState();
}

class _GissCheckboxState extends State<GissCheckbox> {
  bool _isChecked = false;

  onValueChanged(bool? isChecked) {
    setState(() => _isChecked = isChecked!);
    widget.onChecked(isChecked);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.blue;
    }

    return Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: widget.isChecked || _isChecked,
        onChanged: onValueChanged);
  }
}
