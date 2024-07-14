import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/customswichbutton.dart';
import 'package:flutter_application/wedgets/custtomtogglebuttoncool.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_application/wedgets/startstopbutton.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Carcontrol extends StatefulWidget {
  const Carcontrol({super.key});

  @override
  State<Carcontrol> createState() => _CarcontrolState();
}

class _CarcontrolState extends State<Carcontrol> {
  BluetoothConnection? _connection;
  ESP32Controller? _esp32Controller;
  MessageHandler? _messageHandler;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler!);
    _checkBluetoothConnection();
  }

  void _checkBluetoothConnection() async {
    // Check the Bluetooth connection status here and update _isConnected
    // For example:
    // _isConnected = await _esp32Controller?.isConnected();
    setState(() {
      _isConnected =
          _connection != null; // Update this based on actual connection logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Control Car',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              StartStopButton(
                onStartTap: () {
                  _esp32Controller?.sendCommand('STC');
                },
                onStopTap: () {
                  _esp32Controller?.sendCommand('SPC');
                },
                isConnected: _isConnected, // Pass connection status here
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CustomToggleButtonControl(
                        onTapOn: () {
                          _showSavemodeDialog();
                        },
                        onTapOff: () {
                          _esp32Controller?.sendCommand('SF');
                        },
                        onSvg: 'assets/svaemodeoff.svg',
                        offSvg: 'assets/svaemodeon.svg',
                        ontext: 'Save Mode On',
                        offtext: 'Save mode Off',
                        isConnected:
                            _isConnected, // Pass connection status here
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      CustomToggleButtonControl(
                        onTapOn: () {
                          _esp32Controller?.sendCommand('AO');
                        },
                        onTapOff: () {
                          _esp32Controller?.sendCommand('AF');
                        },
                        onSvg: 'assets/airon.svg',
                        offSvg: 'assets/airoff.svg',
                        ontext: 'AirConditioner On',
                        offtext: 'AirConditioner Off',
                        isConnected:
                            _isConnected, // Pass connection status here
                      ),
                    ],
                  ),
                  CustomSwitchButton(
                    onTapLocked: () {
                      _esp32Controller?.sendCommand('CL');

                      // Code to execute when the button is switched to "locked"
                    },
                    onTapOpened: () {
                      // Code to execute when the button is switched to "opend"
                      _esp32Controller?.sendCommand('CO');
                    },
                    isConnected: _isConnected, // Pass connection status here
                  ),
                  Column(
                    children: [
                      CustomToggleButtonControl(
                        onTapOn: () {
                          _esp32Controller?.sendCommand('VO');
                        },
                        onTapOff: () {
                          _esp32Controller?.sendCommand('VF');
                        },
                        onSvg: 'assets/contactoff.svg',
                        offSvg: 'assets/contacton.svg',
                        ontext: 'Contact On',
                        offtext: 'Contact Off',
                        isConnected:
                            _isConnected, // Pass connection status here
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

  void _showSavemodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Row(
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
          content: const Text(
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
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
}
