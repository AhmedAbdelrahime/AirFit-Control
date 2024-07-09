import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/auth/singinscreen.dart';
import 'package:flutter_application/wedgets/cousetombutton.dart';
import 'package:flutter_application/wedgets/custom_text_field.dart';
import 'package:flutter_application/wedgets/snakbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserIdScreen extends StatefulWidget {
  @override
  _UserIdScreenState createState() => _UserIdScreenState();
}

class _UserIdScreenState extends State<UserIdScreen>
    with WidgetsBindingObserver {
  final TextEditingController _userIdController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isLoading = false;
  String qrText = 'Scan a QR code';

  void _checkUserId() async {
    String userId = _userIdController.text.trim();
    if (userId.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      setState(() {
        _isLoading = false;
      });

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('email') && userData.containsKey('name')) {
          // Navigate to Google Sign-In screen and verify email
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleSignInScreen(
                    userId: userId, userEmail: userData['email']),
              ));
        } else {
          // Navigate to Google Sign-In screen to store email and name
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleSignInScreen(userId: userId),
              ));
        }
      } else {
        // Show a message if user ID is not found
        SnackbarHelper(context).showMessage(
          'Invalid QR or Serial number. Please enter a valid User QR.',
          backgroundColor: Colors.redAccent,
        );
      }
    } else {
      SnackbarHelper(context).showMessage(
        'Please enter a valid User ID.',
        backgroundColor: Colors.redAccent,
      );
      // Show error if user ID is empty
    }
  }

  void _onQRViewCreated(Barcode qrCode) {
    if (qrCode.rawValue != null) {
      setState(() {
        _userIdController.text = qrCode.rawValue!;
        qrText = qrCode.rawValue!;
      });
      _checkUserId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan QR",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(width: 10),
            FaIcon(
              FontAwesomeIcons.qrcode,
              color: Colors.blue,
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Welcome to Airfit App. First step, scan the QR code of the control device to access the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: (BarcodeCapture barcodeCapture) {
                      final Barcode qrCode = barcodeCapture.barcodes.first;
                      _onQRViewCreated(qrCode);
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Image.asset(
                      'assets/image2.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.white70),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white70)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Enter the serial number of the device here',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Coustemtextfeild(
                controller: _userIdController,
                hintText: "QG56EHXXXXXXXXXXXX",
                icon: FontAwesomeIcons.qrcode,
                inputType: TextInputType.text,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ) // Show loading indicator when loading
                    : Cousetombutton(
                        text: 'Next',
                        icon: FontAwesomeIcons.arrowRight,
                        onpressed: _checkUserId)),
          ],
        ),
      ),
    );
  }
}
