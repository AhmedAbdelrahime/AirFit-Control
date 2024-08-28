import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/wedgets/cousetombutton.dart';
import 'package:flutter_application/wedgets/custom_text_field.dart';
import 'package:flutter_application/wedgets/snakbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application/screens/homescreen/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  final String userId;

  const LoginScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSigningIn = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase using email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final User user = userCredential.user!;
      final prefs = await SharedPreferences.getInstance();

      // Fetch the stored email from Firestore for the given user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Check if the entered email matches the stored email
        if (user.email == userData['email']) {
          // Store authentication state and user ID in SharedPreferences
          prefs.setBool('isAuthenticated', true);
          prefs.setString('userId', widget.userId);

          // Navigate to HomeScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else {
          // Email does not match; show an error message
          SnackbarHelper(context).showMessage(
            'The email you entered does not match the email associated with this User ID.',
            backgroundColor: Colors.redAccent,
          );
          await FirebaseAuth.instance.signOut();
        }
      } else {
        // User ID not found; show an error message
        SnackbarHelper(context).showMessage(
          'User ID not found.',
          backgroundColor: Colors.redAccent,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Use the error handling function
      SnackbarHelper(context).showMessage(handleFirebaseAuthError(e));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
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
      prefs.setString('userId', widget.userId);

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(widget.userId).set({
          'email': user.email,
          'name': user.displayName,
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else if (user.email ==
          (userDoc.data() as Map<String, dynamic>)['email']) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        SnackbarHelper(context).showMessage(
          'Signed-in email does not match stored email.',
        );
        await FirebaseAuth.instance.signOut();
        prefs.setBool('isAuthenticated', false);
      }
    } on FirebaseAuthException catch (e) {
      // Use the error handling function
      SnackbarHelper(context).showMessage(handleFirebaseAuthError(e));
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController _forgotPasswordController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust overall padding here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: _forgotPasswordController,
                  hintText: "Enter your email",
                  icon: FontAwesomeIcons.envelope,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
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
                    SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final email = _forgotPasswordController.text.trim();
                        if (email.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            SnackbarHelper(context).showMessage(
                                'Password reset email sent. Please check your inbox.');
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            SnackbarHelper(context)
                                .showMessage(handleFirebaseAuthError(e));
                          }
                        } else {
                          SnackbarHelper(context).showMessage(
                              'Please enter a valid email address.');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Login',
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
                  'Welcome Back to AirFit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please log in with your email and password to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  icon: FontAwesomeIcons.envelope,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  icon: FontAwesomeIcons.lock,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Cousetombutton(
                        text: 'Login',
                        icon: FontAwesomeIcons.arrowRight,
                        onpressed: _signInWithEmailAndPassword,
                      ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _showForgotPasswordDialog,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                _isSigningIn
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : GestureDetector(
                        onTap: _signInWithGoogle,
                        child: Container(
                          height: 80,
                          width: 350,
                          child: Image.asset(
                            'assets/androidsi.png', // Replace with your Google icon asset path
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user with this email has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email and password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An undefined Error happened.';
    }
  }
}
