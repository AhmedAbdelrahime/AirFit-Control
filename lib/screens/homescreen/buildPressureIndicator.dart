// ignore: file_names
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/circlerprogress.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_application/wedgets/uppsi.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Buildpressureindicator extends StatefulWidget {
  const Buildpressureindicator({super.key});

  @override
  State<Buildpressureindicator> createState() => _BuildpressureindicatorState();
}

class _BuildpressureindicatorState extends State<Buildpressureindicator>
    with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> pressureAnimation;
  BluetoothConnection? _connection;
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  double currentValue = 290;
  bool _isPressed = false;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;
  int front = 0;
  int rear = 0;
  ESP32Controller? _esp32Controller;
  late MessageHandler _messageHandler;

  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler);
    _requestPermission();

    _initializeBluetoothState();
    _bluetooth.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state.isEnabled;
      });
    });
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    pressureAnimation =
        Tween<double>(begin: 0, end: currentValue).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    progressController.forward();
  }

  void _requestPermission() async {
    await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  void _resetAndSendData() {
    if (_connection == null || !_connection!.isConnected) {
      _messageHandler.showMessage('Not connected to any device');
      setState(() {
        pressureAnimation =
            Tween<double>(begin: 0, end: 0).animate(progressController);
      });
      progressController.forward(from: 0);
      return;
    }

    _esp32Controller?.sendCommand('E');

    progressController.forward();
  }

  Future<void> _initializeBluetoothState() async {
    final state = await _bluetooth.state;
    setState(() {
      _bluetoothState = state.isEnabled;
    });
  }

  void _showBluetoothDialog() async {
    if (!_bluetoothState) {
      await _bluetooth.requestEnable();
      setState(() {
        _bluetoothState = true;
      });
    }
    _getDevices();
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              'Bluetooth Devices',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoDevice(),
                Expanded(child: _listDevices()),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Close', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            // Adjust vertical padding as needed
          ),
        );
      },
    );
  }

  Future<void> _getDevices() async {
    setState(() {});

    try {
      var res = await _bluetooth.getBondedDevices();
      setState(() {
        _devices = res;
        if (_devices.isEmpty) {
          _messageHandler.showMessage("No devices found");
        }
      });
    } catch (e) {
      _messageHandler.showMessage("Error retrieving devices: $e");
    } finally {
      setState(() {});
    }
  }

  Widget _infoDevice() {
    return ListTile(
      tileColor: Colors.black12,
      title: Text(
        _deviceConnected?.name ?? "",
        style: const TextStyle(color: Colors.white),
      ),
      trailing: _connection?.isConnected ?? false
          ? TextButton(
              onPressed: () async {
                await _connection?.finish();
                setState(() => _deviceConnected = null);
                _messageHandler.showMessage('Disconnected', Colors.orange);
              },
              child: const Text("Disconnect",
                  style: TextStyle(color: Colors.white)),
            )
          : TextButton(
              onPressed: _getDevices,
              child: const Text("View devices",
                  style: TextStyle(color: Colors.white)),
            ),
    );
  }

  Widget _listDevices() {
    if (_devices.isEmpty) {
      return const Center(
        child: Text(
          'No devices found',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: _devices.map((device) {
              return ListTile(
                title: Text(
                  device.name ?? device.address,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Button border radius
                    ),
                  ),
                  onPressed: () => _connectToDevice(device),
                  child: const Text('Connect'),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {});

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _deviceConnected = device;
        _devices = [];
      });
      _receiveData();
      _messageHandler.showMessage(
          'Connected to ${device.name ?? device.address}', Colors.green);
    } catch (e) {
      _messageHandler.showMessage('Failed to connect', Colors.red);
    } finally {
      setState(() {});
    }
  }

  void _receiveData() {
    _connection?.input?.listen((Uint8List data) {
      String receivedString = String.fromCharCodes(data);
      double receivedValue = double.tryParse(receivedString) ?? 0.0;

      setState(() {
        currentValue = receivedValue.clamp(0, 290);
        pressureAnimation = Tween<double>(begin: 0, end: currentValue)
            .animate(progressController);
      });

      progressController.forward(from: 0);
    }).onDone(() {
      if (_connection?.isConnected ?? false) {
        _messageHandler.showMessage('Disconnected from device', Colors.orange);
      }
    });
  }

  @override
  void dispose() {
    _connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Up(),
            const SizedBox(
              width: 20,
            ),
            CustomPaint(
              foregroundPainter: CircleProgress(pressureAnimation.value),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _resetAndSendData,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1D2124), Color(0xFF2E3138)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${pressureAnimation.value.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'PSI',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPressed = !_isPressed;
                });
                _showBluetoothDialog();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                width: _isPressed ? 50 : 40,
                height: _isPressed ? 50 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1499EC), Color(0xFF036EBE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: _isPressed
                      ? [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.bluetoothB,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        // SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: SwitchListTile(
            value: _bluetoothState,
            onChanged: (bool value) async {
              if (value) {
                await _bluetooth.requestEnable();
                // _showBluetoothDialog();
              } else {
                await _bluetooth.requestDisable();
              }
              setState(() => _bluetoothState = value);
            },
            tileColor: Colors.black26,
            title: Text(
              _bluetoothState ? "Bluetooth On" : "Bluetooth Off",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
