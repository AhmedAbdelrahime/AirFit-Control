import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/screens/homescreen/homescreen.dart';
// import 'package:flutter_application/screens/test.dart';
import 'package:flutter_application/wedgets/snakbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInScreen extends StatefulWidget {
  final String userId;
  final String? userEmail;

  const GoogleSignInScreen({Key? key, required this.userId, this.userEmail})
      : super(key: key);

  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isSigningIn = true;
    });

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      setState(() {
        _isSigningIn = false;
      });
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user!;
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuthenticated', true);
      prefs.setString('userId', widget.userId); // Store custom user ID

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      if (widget.userEmail == null) {
        await _firestore.collection('users').doc(widget.userId).set({
          'email': user.email,
          'name': user.displayName,
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          //Test   HomeScreen
          (route) => false,
        );
      } else if (user.email == widget.userEmail) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          //Test   HomeScreen
          (route) => false,
        );
      } else {
        SnackbarHelper(context).showMessage(
          'Signed-in email does not match stored email.',
        );
        await FirebaseAuth.instance.signOut();
        prefs.setBool('isAuthenticated', false);
      }
    } catch (e) {
      SnackbarHelper(context).showMessage('An error occurred: $e');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Sign in with Google',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/welcom.png', // Replace with your image asset path
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to AirFit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please sign in with your Google account to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white70),
                SizedBox(height: 20),
                _isSigningIn
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : GestureDetector(
                        onTap: () => _signInWithGoogle(context),
                        child: Container(
                          height: 80,
                          width: 350,
                          child: Image.asset(
                            'assets/image4.png', // Replace with your Google icon asset path
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                Text(
                  'By signing in, you agree to our Terms of Service and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
