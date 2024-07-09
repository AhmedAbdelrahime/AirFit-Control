import 'package:flutter/material.dart';

class CustomSensor extends StatefulWidget {
  final String mainText;
  final String subText;
  final IconData icon;

  const CustomSensor({
    Key? key,
    required this.mainText,
    required this.subText,
    required this.icon,
  }) : super(key: key);

  @override
  State<CustomSensor> createState() => _CustomSensorState();
}

class _CustomSensorState extends State<CustomSensor> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 50,
          child: Stack(
            children: [
              Positioned(
                left: 6,
                top: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mainText,
                      style: TextStyle(
                        color: Color(0xFF8A8A8A),
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.subText,
                      style: TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 2, // Adjust width to fit the icon properly
          height: 20, // Adjust height to fit the icon properly
          child: Icon(
            widget.icon,
            // size: 16, // Adjust icon size as needed
            color: Colors.grey, // Set icon color
          ),
        ),
      ],
    );
  }
}
