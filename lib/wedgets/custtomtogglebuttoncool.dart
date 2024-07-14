import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomToggleButtonControl extends StatefulWidget {
  final VoidCallback onTapOn;
  final VoidCallback onTapOff;
  final bool isConnected;

  final String onSvg;
  final String offSvg;
  final String ontext;
  final String offtext;

  const CustomToggleButtonControl({
    super.key,
    required this.onTapOn,
    required this.onTapOff,
    required this.onSvg,
    required this.offSvg,
    required this.ontext,
    required this.offtext,
    required this.isConnected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomToggleButtonControlState createState() =>
      _CustomToggleButtonControlState();
}

class _CustomToggleButtonControlState extends State<CustomToggleButtonControl> {
  bool isOn = false;
  late MessageHandler _messageHandler;
  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
  }

  void _toggleButton() {
    if (widget.isConnected) {
      setState(() {
        isOn = !isOn;
        if (isOn) {
          widget.onTapOn();
        } else {
          widget.onTapOff();
        }
      });
    } else {
      _messageHandler.showMessage('Not connected to Bluetooth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleButton,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: isOn
                  ? Colors.black.withOpacity(0.7) // Background color when "on"
                  : Colors.black
                      .withOpacity(0.5), // Background color when "off"
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: isOn
                  ? SvgPicture.asset(
                      widget.onSvg,
                    ) // SVG for "on" state
                  : SvgPicture.asset(widget.offSvg), // SVG for "off" state
            ),
          ),
          Text(
            isOn ? widget.ontext : widget.offtext,
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
