import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/custom_toggle_button.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_application/wedgets/sensor.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// Import the new class

class Buildtogglebutton extends StatefulWidget {
  const Buildtogglebutton({super.key});

  @override
  State<Buildtogglebutton> createState() => _BuildtogglebuttonState();
}

class _BuildtogglebuttonState extends State<Buildtogglebutton> {
  int selectedIndex = 1;
  BluetoothConnection? _connection;
  ESP32Controller? _esp32Controller;
  MessageHandler? _messageHandler;

  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler!);
  }

  void _handleButtonToggle(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Send command based on selected index
    String command;
    switch (index) {
      case 0:
        command = 'H';
        break;
      case 1:
        command = 'R';
        break;
      case 2:
        command = 'L';
        break;
      case 3:
        command = 'P';
        break;
      default:
        command = '';
    }

    if (command.isNotEmpty) {
      _esp32Controller?.sendCommand(command);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 140,
              ),
              CustomSensor(
                mainText: 'Sensor',
                subText: 'Pressure',
                icon: Icons.speed,
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                CustomToggleButton(
                  buttonLabels: const ['HIGH', 'RIDE', 'LOW', 'P'],
                  onChanged: _handleButtonToggle,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomSensor(
                mainText: 'Bettery',
                subText: 'Save',
                icon: Icons.battery_charging_full,
              ),
              SizedBox(
                height: 100,
              ),
              CustomSensor(
                mainText: 'Delay',
                subText: '0.2s',
                icon: Icons.timer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
