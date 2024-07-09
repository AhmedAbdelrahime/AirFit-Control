import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/munalcontrol.center.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Buildmanualcontrolboutton extends StatefulWidget {
  const Buildmanualcontrolboutton({super.key});

  @override
  State<Buildmanualcontrolboutton> createState() =>
      _BuildmanualcontrolbouttonState();
}

class _BuildmanualcontrolbouttonState extends State<Buildmanualcontrolboutton> {
  int front = 0;
  int rear = 0;
  String frontText = "";

  bool isFrontLeftUpPressed = false;
  bool isFrontLeftDownPressed = false;
  bool isFrontRightUpPressed = false;
  bool isFrontRightDownPressed = false;
  bool isManualControlHighlightedUp = false;
  bool isManualControlHighlighteDown = false;
  double currentValue = 0;
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  BluetoothConnection? _connection;
  Future<void> _sendCommandToESP32(String command) async {
    if (_connection != null && _connection!.isConnected) {
      try {
        _sendData(command);
        _showMessage("Command sent: $command", Colors.green);
      } catch (e) {
        _showMessage("Failed to send command: $e", Colors.red);
      }
    } else {
      _showMessage("Not connected to any device", Colors.red);
    }
  }

  void _receiveData() {
    _connection!.input!.listen((Uint8List data) {
      String receivedData = ascii.decode(data);
      List<String> sensorValues = receivedData.trim().split(',');
      if (sensorValues.length >= 3) {
        setState(() {
          currentValue = double.parse(sensorValues[0]);
          front = int.parse(sensorValues[1]);
          rear = int.parse(sensorValues[2]);
        });
      }
    }).onDone(() {
      _showMessage('Disconnected by remote request', Colors.orange);
    });
  }

  void _sendData(String data) {
    _connection?.output.add(ascii.encode(data));
  }

  void _showMessage(String message, [Color backgroundColor = Colors.red]) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the border radius as needed
        ),
        margin: EdgeInsets.all(10), // Adjust the margin as needed
        elevation: 6, // Adjust the elevation as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildControlButton('', rear, 'frontLeft'),
        Column(
          children: [
            GestureDetector(
              onTapDown: (_) {
                _sendCommandToESP32('FRU');
                setState(() {
                  isManualControlHighlightedUp = true;
                  frontText = '  Up   ';
                });
              },
              onTapUp: (_) {
                _sendCommandToESP32('S');
                setState(() {
                  isManualControlHighlightedUp = false;
                });
              },
              onTapCancel: () {
                _sendCommandToESP32('S');
                setState(() {
                  isManualControlHighlightedUp = false;
                });
              },
              child: MunalcontrolCneter(
                icon1: FontAwesomeIcons.angleUp,
                icon2: FontAwesomeIcons.angleUp,
                icon3: FontAwesomeIcons.angleUp,
                icon1Opacity: 1,
                icon2Opacity: .5,
                icon3Opacity: .7,
                isHighlighted: isManualControlHighlightedUp,
              ),
            ),
            SizedBox(height: 50),
            Text(
              frontText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTapDown: (_) {
                _sendCommandToESP32('FRD');
                setState(() {
                  isManualControlHighlighteDown = true;
                  frontText = 'Down';
                });
              },
              onTapUp: (_) {
                _sendCommandToESP32('S');
                setState(() {
                  isManualControlHighlighteDown = false;
                });
              },
              onTapCancel: () {
                _sendCommandToESP32('S');
                setState(() {
                  isManualControlHighlighteDown = false;
                });
              },
              child: MunalcontrolCneter(
                icon1: FontAwesomeIcons.angleDown,
                icon2: FontAwesomeIcons.angleDown,
                icon3: FontAwesomeIcons.angleDown,
                icon1Opacity: .5,
                icon2Opacity: 1,
                icon3Opacity: .7,
                isHighlighted: isManualControlHighlighteDown,
              ),
            )
          ],
        ),
        _buildControlButton('', front, 'frontRight'),
      ],
    );
  }

  Widget _buildControlButton(String text, int value, String controlType) {
    return Column(
      children: [
        // Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          width: 80,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: Colors.black45),
            gradient: LinearGradient(
              colors: [Colors.black, Colors.grey[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  FontAwesomeIcons.angleUp,
                  () => _sendCommandToESP32(
                      controlType == 'frontLeft' ? 'RU' : 'FU'),
                  () => _sendCommandToESP32('S'),
                  controlType == 'frontLeft'
                      ? isFrontLeftUpPressed
                      : isFrontRightUpPressed,
                  controlType == 'frontLeft'
                      ? (bool pressed) => setState(() {
                            isFrontLeftUpPressed = pressed;
                            frontText = 'Rear';
                          })
                      : (bool pressed) => setState(() {
                            isFrontRightUpPressed = pressed;
                            frontText = 'Front';
                          }),
                ),
                Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                _buildIconButton(
                  FontAwesomeIcons.angleDown,
                  () => _sendCommandToESP32(
                      controlType == 'frontLeft' ? 'RD' : 'FD'),
                  () => _sendCommandToESP32('S'),
                  controlType == 'frontLeft'
                      ? isFrontLeftDownPressed
                      : isFrontRightDownPressed,
                  controlType == 'frontLeft'
                      ? (bool pressed) => setState(() {
                            isFrontLeftDownPressed = pressed;
                            frontText = 'Rear';
                          })
                      : (bool pressed) => setState(() {
                            isFrontRightDownPressed = pressed;
                            frontText = 'Front';
                          }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData iconData, VoidCallback onPressed,
      VoidCallback onReleased, bool isPressed, Function(bool) onPressedState) {
    return GestureDetector(
      onTapDown: (_) {
        onPressed();
        onPressedState(true);
      },
      onTapUp: (_) {
        onReleased();
        onPressedState(false);
      },
      onTapCancel: () {
        onReleased();
        onPressedState(false);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPressed
                ? [Colors.blue, Colors.blueAccent]
                : [Colors.black, Colors.grey[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: const Offset(2.0, 2.0),
            ),
          ],
          border: Border.all(
            color: isPressed ? Colors.blueAccent : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 10,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
