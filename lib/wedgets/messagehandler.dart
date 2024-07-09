import 'package:flutter/material.dart';

class MessageHandler {
  final BuildContext context;

  MessageHandler(this.context);

  void showMessage(String message, [Color backgroundColor = Colors.red]) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // Adjust the border radius as needed
      ),
      margin: EdgeInsets.all(10), // Adjust the margin as needed
      elevation: 6, // Adjust the elevation as needed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
