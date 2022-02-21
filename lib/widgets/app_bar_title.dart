import 'package:flutter/material.dart';
import 'package:aivoiceweather/res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/firebase_logo.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'ClimApp',
          style: TextStyle(
            color: CustomColors.firebaseGrey,
            fontSize: 18,
          ),
        ),
        Text(
          ' Authentication',
          style: TextStyle(
            color: CustomColors.firebaseGrey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}