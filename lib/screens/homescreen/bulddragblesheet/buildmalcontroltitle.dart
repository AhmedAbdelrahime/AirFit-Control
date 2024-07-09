import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Buildmalcontroltitle extends StatefulWidget {
  const Buildmalcontroltitle({super.key});

  @override
  State<Buildmalcontroltitle> createState() => _BuildmalcontroltitleState();
}

class _BuildmalcontroltitleState extends State<Buildmalcontroltitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Manual Control',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF1499EC), Color(0xFF036EBE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 8,
                    child: FaIcon(
                      FontAwesomeIcons.angleUp,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: FaIcon(
                      FontAwesomeIcons.angleUp,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show all options to Control each Side or each axcel and compressor mode.',
                style: TextStyle(
                  color: Color(0xFF8A8A8A),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
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
                      gradient: const LinearGradient(
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
                const Positioned(
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
                const Positioned(
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
      ),
    );
  }
}
