// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application/auth/singinscreen.dart';
// import 'package:flutter_application/wedgets/cousetombutton.dart';
// import 'package:flutter_application/wedgets/custom_text_field.dart';
// import 'package:flutter_application/wedgets/snakbar.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> with WidgetsBindingObserver {
//   final MobileScannerController controller = MobileScannerController();
//   final TextEditingController _idController = TextEditingController();
//   bool _isLoading = false; // Loading state

//   String qrText = 'Scan a QR code';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     controller.barcodes.listen((barcode) {
//       setState(() {
//         final BarcodeCapture capture = barcode as BarcodeCapture;
//         qrText = capture.barcodes.first.displayValue ?? 'Unknown';
//         authenticate(qrText); // Authenticate with the scanned QR code value.
//       });
//     });
//     controller.start();
//   } 

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!controller.value.isInitialized) {
//       return;
//     }
//     switch (state) {
//       case AppLifecycleState.resumed:
//         controller.start();
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//         controller.stop();
//         break;
//       default:
//         break;
//     }
//   }

//   void authenticate(String userId) async {
//     try {
//       setState(() {
//         _isLoading = true; // Show loading indicator
//       });

//       // Simulate authentication process
//       await Future.delayed(
//           Duration(seconds: 2)); // Replace with actual authentication code

//       if (userId.isNotEmpty) {
//         bool userExists = await checkUserInFirestore(userId);
//         if (userExists) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('userId', userId);
//           navigateToNextStep();
//         } else {
//           SnackbarHelper(context).showMessage(
//             'The Serial Number was not found',
//             backgroundColor: Colors.redAccent,
//           );
//         }
//       } else {
//         SnackbarHelper(context).showMessage(
//           'Invalid QR or Serial number. Please enter a valid User QR.',
//           backgroundColor: Colors.redAccent,
//         );
//       }
//     } catch (e) {
//       SnackbarHelper(context).showMessage(
//         'An error occurred during authentication',
//         backgroundColor: Colors.redAccent,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false; // Hide loading indicator
//       });
//     }
//   }

//   Future<bool> checkUserInFirestore(String userId) async {
//     DocumentSnapshot userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     return userDoc.exists;
//   }

//   void navigateToNextStep() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => GoogleSignInScreen(
//                 userId: '',
//               )),
//     );
//   }

//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.black87,
//         title: const Text(
//           "Scan QR",
//           style: TextStyle(color: Colors.white70),
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//               child: Text(
//                 'Welcome to Airfit App. First step, scan the QR code of the control device to access the app.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black38,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Stack(
//               children: [
//                 Container(
//                   height: 400,
//                   width: double.infinity,
//                   child: MobileScanner(
//                     controller: controller,
//                   ),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 60),
//                     child: Image.asset(
//                       'assets/Vector.png',
//                       height: 250,
//                       width: 250,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Row(
//               children: [
//                 Expanded(
//                   child: Divider(color: Colors.white70),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     "OR",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: Divider(color: Colors.white70)),
//               ],
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 24),
//               child: Text(
//                 'Enter the serial number of the device here',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Coustemtextfeild(
//                 controller: _idController,
//                 hintText: "QG56EHXXXXXXXXXXXX",
//                 icon: FontAwesomeIcons.qrcode,
//                 inputType: TextInputType.text,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: _isLoading
//                     ? CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ) // Show loading indicator when loading
//                     : Cousetombutton(
//                         text: 'Authenticate',
//                         icon: FontAwesomeIcons.arrowRight,
//                         onpressed: () {
//                           String userId = _idController.text.trim();
//                           if (userId.isNotEmpty) {
//                             authenticate(
//                                 userId); // Authenticate with the text field value.
//                           } else {
//                             SnackbarHelper(context).showMessage(
//                               'Please enter a Serial Number',
//                               backgroundColor: Colors.redAccent,
//                             );
//                           }
//                         },
//                       )),
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Text(
//                   'Already entered or scanned your Serial Number before?',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Add functionality here
//                   },
//                   child: const Text(
//                     'Click Here',
//                     style: TextStyle(
//                       color: Colors.lightBlue,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
