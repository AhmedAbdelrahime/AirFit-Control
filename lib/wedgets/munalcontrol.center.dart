import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MunalcontrolCneter extends StatelessWidget {
  const MunalcontrolCneter(
      {super.key,
      required this.icon1,
      required this.icon2,
      required this.icon3,
      required this.icon1Opacity,
      required this.icon2Opacity,
      required this.icon3Opacity,
      this.isHighlighted = false});
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final double icon1Opacity;
  final double icon2Opacity;
  final double icon3Opacity;
  final bool isHighlighted;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      decoration: ShapeDecoration(
          gradient: LinearGradient(
            // begin: Alignment(0.00, -1.00),
            // end: Alignment(0, 1),
            colors: [Color(0xFF2C3034), Color(0xFF27292E)],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 3,
              color: isHighlighted ? Colors.blue : Color(0xFF151515),
            ),
            borderRadius: BorderRadius.circular(71),
          )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Opacity(
              opacity: icon1Opacity,
              child: FaIcon(
                icon1,
                color: isHighlighted ? Colors.blue : Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 14,
            child: Opacity(
              opacity: icon2Opacity,
              child: FaIcon(
                icon2,
                color: isHighlighted ? Colors.blue : Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 23,
            child: Opacity(
              opacity: icon3Opacity,
              child: FaIcon(
                icon3,
                color: isHighlighted ? Colors.blue : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
