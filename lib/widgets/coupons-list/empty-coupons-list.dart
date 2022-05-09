import 'package:flutter/material.dart';

class EmptyCouponsList extends StatelessWidget {
  const EmptyCouponsList({Key? key, required this.description})
      : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'הרשימה ריקה',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
