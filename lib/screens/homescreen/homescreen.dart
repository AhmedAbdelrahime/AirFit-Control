import 'dart:typed_data';
import 'package:flutter_application/screens/homescreen/buildDraggableSheet.dart';
import 'package:flutter_application/screens/homescreen/buildPressureIndicator.dart';
import 'package:flutter_application/screens/homescreen/buildToggleButton.dart';
import 'package:flutter_application/screens/homescreen/drawer.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_application/wedgets/snakbar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late String _userId = '';
  late String _userName = '';
  late String _userEmail = '';
  bool _isLoading = true;

  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BluetoothDevice? _deviceConnected;
  BluetoothConnection? _connection;
  ESP32Controller? _esp32Controller;
  MessageHandler? _messageHandler;

  @override
  void initState() {
    super.initState();

    _fetchUserData();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler!);
    _requestPermission();
    _initializeBluetoothState();
    _bluetooth.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state.isEnabled;
      });
    });
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? '';

    if (_userId.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = userData['name'];
          _userEmail = userData['email'];
          _isLoading = false;
        });
      } else {
        // Handle the case where the user ID does not exist
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User ID not found.'),
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(10), // Adjust the margin as needed
          elevation: 6, //
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Adjust the border radius as needed
          ),
        ));
      }
    } else {
      // Handle the case where the user ID is not found in SharedPreferences
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User ID not found in preferences.'),
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(10), // Adjust the margin as needed
        elevation: 6, //
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the border radius as needed
        ),
      ));
    }
  }

  Future<void> _initializeBluetoothState() async {
    final state = await _bluetooth.state;
    setState(() {
      _bluetoothState = state.isEnabled;
    });

    if (_deviceConnected != null && _connection == null) {
      _connectToDevice(_deviceConnected!);
    }
  }

  void _requestPermission() async {
    await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      setState(() {
        _connection = connection;
        _deviceConnected = device;
      });
      _esp32Controller = ESP32Controller(_connection, _messageHandler!);
      _esp32Controller?.sendCommand(_userId);
    } catch (e) {
      print('Error connecting to device: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to connect to device.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color

      key: _scaffoldKey, // Assign the key to Scaffold

      drawer: const DrwerPage(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildHeader(),
                    const Buildpressureindicator(),
                    const Buildtogglebutton(),
                  ],
                ),
              ),
            ),
            const Builddraggablesheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 94,
                  height: 34,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Air',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'Fit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 23,
                        child: Text(
                          "Set your ride height",
                          style: TextStyle(
                            color: Color(0xFF8C9399),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Open drawer on click
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 0),
            _deviceConnected == null
                ? Container(
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 100),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  )
                : Container(
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 100),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
            Text(
              _deviceConnected == null ? '  Not Connected' : ' Connected',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
