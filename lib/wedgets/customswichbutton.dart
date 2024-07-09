import 'package:flutter/material.dart';

class CustomSwitchButton extends StatefulWidget {
  final VoidCallback onTapLocked;
  final VoidCallback onTapOpened;

  CustomSwitchButton({required this.onTapLocked, required this.onTapOpened});

  @override
  _CustomSwitchButtonState createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  bool isOn = false;

  void _toggleSwitch() {
    setState(() {
      isOn = !isOn;
      if (isOn) {
        widget.onTapOpened();
      } else {
        widget.onTapLocked();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                // Swiped up
                setState(() {
                  isOn = true;
                  widget.onTapOpened();
                });
              } else if (details.primaryVelocity! > 0) {
                // Swiped down
                setState(() {
                  isOn = false;
                  widget.onTapLocked();
                });
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 240,
              width: 100,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey.shade900,
                    const Color.fromARGB(255, 48, 60, 65)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                    color: const Color.fromARGB(255, 78, 78, 78), width: 11),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: isOn ? 4 : 146,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOn ? Colors.blueAccent : Colors.redAccent[400],
                      ),
                      child: Icon(
                        isOn ? Icons.key : Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: isOn ? 146 : 4,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 10,
                            blurRadius: 30,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        isOn ? Icons.lock : Icons.key,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    child: Icon(
                      isOn
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: isOn
                          ? Colors.lightBlue.withOpacity(0.5)
                          : Colors.lightBlue.withOpacity(0.8),
                      size: 30,
                    ),
                  ),
                  Positioned(
                    top: 100,
                    child: Icon(
                      isOn
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: isOn
                          ? Colors.lightBlue.withOpacity(0.8)
                          : Colors.lightBlue.withOpacity(0.5),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle,
              color: Colors.black87,
            ),
            child: Center(
              child: Text(
                isOn ? 'Opend' : 'Locked',
                style: TextStyle(
                  color: isOn ? Colors.blue : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
