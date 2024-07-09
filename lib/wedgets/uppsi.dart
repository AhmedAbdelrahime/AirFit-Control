import 'package:flutter/material.dart';

class Up extends StatefulWidget {
  const Up({super.key});

  @override
  State<Up> createState() => _UpState();
}

class _UpState extends State<Up> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 59.50,
          child: Stack(
            children: [
              Positioned(
                left: 22,
                top: 1.50,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(1.57),
                  child: Container(
                    width: 58,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF141515),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 10,
                child: Text(
                  '50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 34,
                child: Text(
                  '50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 10,
                child: Text(
                  '50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 34,
                child: Text(
                  '50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 54,
          height: 23,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF050607), Color(0xFF1B1F24)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 5,
                top: 4,
                child: Container(
                  width: 25,
                  height: 15,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(1.00, 0.00),
                      end: Alignment(-1, 0),
                      colors: [Color(0xFF0568B0), Color(0xFF13A0F6)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 6,
                child: SizedBox(
                  width: 15,
                  height: 9,
                  child: Text(
                    'Psi',
                    style: TextStyle(
                      color: Color(0xFFE6E6E6),
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 5,
                child: Text(
                  '%',
                  style: TextStyle(
                    color: Color(0xFF6C6C6C),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
