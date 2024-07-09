import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/customswichbutton.dart';
import 'package:flutter_application/wedgets/custtomtogglebuttoncool.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_application/wedgets/startstopbutton.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Carcontrol extends StatefulWidget {
  const Carcontrol({super.key});

  @override
  State<Carcontrol> createState() => _CarcontrolState();
}

class _CarcontrolState extends State<Carcontrol> {
  BluetoothConnection? _connection;
  ESP32Controller? _esp32Controller;
  MessageHandler? _messageHandler;
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler!);
  }

  void _showSavemodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Warning',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Save Mode will secure your vehicle and prevent unauthorized access. Once enabled, Save Mode will:\n\n- Disable the ignition system.\n- Lock all doors and windows.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _esp32Controller?.sendCommand('SO');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Control Car',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              StartStopButton(
                onStartTap: () {
                  print('start');
                  _esp32Controller?.sendCommand('STC');
                },
                onStopTap: () {
                  print('stop');
                  _esp32Controller?.sendCommand('SPC');
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CustomToggleButtonControl(
                        onTapOn: () {
                          print('on');
                          _showSavemodeDialog();
                        },
                        onTapOff: () {
                          print('of');
                          _esp32Controller?.sendCommand('SF');
                        },
                        onSvg: 'assets/svaemodeoff.svg',
                        offSvg: 'assets/svaemodeon.svg',
                        ontext: 'Save Mode On',
                        offtext: 'Save mode Off',
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      CustomToggleButtonControl(
                        onTapOn: () {
                          print('on');
                          _esp32Controller?.sendCommand('AO');
                        },
                        onTapOff: () {
                          print('of');
                          _esp32Controller?.sendCommand('AF');
                        },
                        onSvg: 'assets/airon.svg',
                        offSvg: 'assets/airoff.svg',
                        ontext: 'AirConditioner On',
                        offtext: 'AirConditioner Off',
                      ),
                    ],
                  ),
                  CustomSwitchButton(
                    onTapLocked: () {
                      _esp32Controller?.sendCommand('CL');

                      // Code to execute when the button is switched to "locked"
                      print('Locked');
                    },
                    onTapOpened: () {
                      // Code to execute when the button is switched to "opend"
                      print('Opend');
                      _esp32Controller?.sendCommand('CO');
                    },
                  ),
                  Column(
                    children: [
                      CustomToggleButtonControl(
                        onTapOn: () {
                          print('on');
                          _esp32Controller?.sendCommand('VO');
                        },
                        onTapOff: () {
                          print('of');
                          _esp32Controller?.sendCommand('VF');
                        },
                        onSvg: 'assets/contactoff.svg',
                        offSvg: 'assets/contacton.svg',
                        ontext: 'Contact On',
                        offtext: 'Contact Off',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
