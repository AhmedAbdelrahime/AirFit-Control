import 'package:flutter/material.dart';
import 'package:flutter_application/screens/carcontrol.dart';
import 'package:flutter_application/screens/getstart.dart';
import 'package:flutter_application/screens/privacypage.dart';
import 'package:flutter_application/screens/termofser.dart';
import 'package:flutter_application/wedgets/espcontroler.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrwerPage extends StatefulWidget {
  const DrwerPage({super.key});

  @override
  State<DrwerPage> createState() => _DrwerPageState();
}

class _DrwerPageState extends State<DrwerPage> {
  bool _pressureReads = false;
  bool _savehight = false;
  // bool _isConnecting = false;
  BluetoothConnection? _connection;
  ESP32Controller? _esp32Controller;
  MessageHandler? _messageHandler;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', false);

    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => Welcomepage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
    _esp32Controller = ESP32Controller(_connection, _messageHandler!);
  }

  void _showWarningDialog() {
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
            'We advise you to activate the pressure sensor reading only when necessary to maintain a fast and smooth user experience.',
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
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
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
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out?',
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
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAirSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: const Text(
            'If you have any air leakage problem, activate this option. The control will automatically maintain the current height.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Drawer(
        clipBehavior: Clip.antiAlias, // Define clipping behavior
        elevation: 1.0, // Elevation for the drawer shadow
        semanticLabel: 'Main Menu', // Accessibility label
        shadowColor: Colors.blue.withOpacity(1), // Shadow color
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(40),
            left: Radius.circular(20),
            // Rounded corners
          ),
        ),
        width: 210.0,

        // Width of the drawer
        surfaceTintColor: Colors.blue.withOpacity(0.7), // Surface tint color
        backgroundColor: Colors.black, // Background color
        child: ListView(
          children: [
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.car,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Car Control',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Carcontrol()),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(
                // ignore: deprecated_member_use
                FontAwesomeIcons.fileAlt,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage(
                        contactEmail: 'airfitment_customer_support@gmail.com'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.fileContract,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsOfServicePage(
                        contactEmail: 'airfitment_customer_support@gmail.com'),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text(
                'Pressure\nReads',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.4),

              secondary: const FaIcon(
                FontAwesomeIcons.droplet,
                color: Color(0xFF8A8A8A),
              ),
              value: _pressureReads, // Boolean value indicating switch state
              onChanged: (bool value) {
                setState(() {
                  _pressureReads = value;
                });
                if (value) {
                  _esp32Controller?.sendCommand('HO');
                  _showWarningDialog();
                } else {
                  _esp32Controller?.sendCommand('HF');
                }
              },
            ),
            SwitchListTile(
              title: const Text(
                'Save\nHeight',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.4),

              secondary: const FaIcon(
                // ignore: deprecated_member_use
                FontAwesomeIcons.save,
                color: Color(0xFF8A8A8A),
              ),
              value: _savehight, // Boolean value indicating switch state
              onChanged: (bool value) {
                setState(() {
                  _savehight = value;
                });
                if (value) {
                  _esp32Controller?.sendCommand('PO');
                  _showAirSaveDialog();
                } else {
                  _esp32Controller?.sendCommand('PF');
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _showLogoutDialog(),
            ),
          ],
        ),
      ),
    );
  }
}
