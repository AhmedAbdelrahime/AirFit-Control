import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cousetombutton extends StatelessWidget {
  const Cousetombutton(
      {super.key, required this.text, this.icon, required this.onpressed});
  final String text;
  final IconData? icon;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      icon: FaIcon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
