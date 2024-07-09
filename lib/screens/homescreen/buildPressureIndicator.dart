import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/circlerprogress.dart';
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
  bool _isConnecting = false;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;
  int front = 0;
  int rear = 0;

  void initState() {
    super.initState();
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
      _showMessage('Not connected to any device', Colors.red);
      setState(() {
        pressureAnimation =
            Tween<double>(begin: 0, end: 0).animate(progressController);
      });
      progressController.forward(from: 0);
      return;
    }

    _sendData('E');

    progressController.forward();
  }

  void _sendData(String data) {
    _connection?.output.add(ascii.encode(data));
  }

  Future<void> _initializeBluetoothState() async {
    final state = await _bluetooth.state;
    setState(() {
      _bluetoothState = state.isEnabled;
    });
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

  void _showBluetoothDialog() async {
    if (!_bluetoothState) {
      await _bluetooth.requestEnable();
      setState(() {
        _bluetoothState = true;
      });
    }
    _getDevices();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: AlertDialog(
            backgroundColor: Colors.black87,
            title: Text(
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
    setState(() {
      _isConnecting = true;
    });

    try {
      var res = await _bluetooth.getBondedDevices();
      setState(() {
        _devices = res;
        if (_devices.isEmpty) {
          _showMessage("No devices found");
        }
      });
    } catch (e) {
      _showMessage("Error retrieving devices: $e");
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  Widget _infoDevice() {
    return ListTile(
      tileColor: Colors.black12,
      title: Text(
        _deviceConnected?.name ?? "",
        style: TextStyle(color: Colors.white),
      ),
      trailing: _connection?.isConnected ?? false
          ? TextButton(
              onPressed: () async {
                await _connection?.finish();
                setState(() => _deviceConnected = null);
                _showMessage('Disconnected', Colors.orange);
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
      return Center(
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
                  style: TextStyle(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Button border radius
                    ),
                  ),
                  onPressed: () => _connectToDevice(device),
                  child: Text('Connect'),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _deviceConnected = device;
        _devices = [];
      });
      _receiveData();
      _showMessage(
          'Connected to ${device.name ?? device.address}', Colors.green);
    } catch (e) {
      _showMessage('Failed to connect', Colors.red);
    } finally {
      setState(() {
        _isConnecting = false;
      });
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
        _showMessage('Disconnected from device', Colors.orange);
      }
    });
  }

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
            Up(),
            SizedBox(
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
                      decoration: BoxDecoration(
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
            SizedBox(
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
                duration: Duration(milliseconds: 200),
                alignment: Alignment.center,
                width: _isPressed ? 50 : 40,
                height: _isPressed ? 50 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF1499EC), Color(0xFF036EBE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: FaIcon(
                  FontAwesomeIcons.bluetoothB,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        // SizedBox(height: 20),
        Container(
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
              style: TextStyle(
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
