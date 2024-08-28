import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/screens/homescreen/homescreen.dart';
import 'package:flutter_application/wedgets/cousetombutton.dart';
import 'package:flutter_application/wedgets/custom_text_field.dart';
import 'package:flutter_application/wedgets/snakbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  final String userId;

  const SignUpScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  void _signUp() async {
    String email = _emailController.text.trim();
    String name = _nameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isNotEmpty &&
        name.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        setState(() {
          _isLoading = true;
        });

        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .set({
            'email': email,
            'name': name,
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } on FirebaseAuthException catch (e) {
          // Use the error handling function
          SnackbarHelper(context).showMessage(handleFirebaseAuthError(e));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        SnackbarHelper(context).showMessage('Passwords do not match.');
      }
    } else {
      SnackbarHelper(context).showMessage('Please fill all fields.');
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();

        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get();

        if (!userDoc.exists) {
          // Save the user to Firestore if they don't exist
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .set({
            'email': user.email,
            'name': user.displayName,
          });
        }

        // Store authentication state and user ID in SharedPreferences
        prefs.setBool('isAuthenticated', true);
        prefs.setString('userId', widget.userId);

        // Navigate to HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/welcom.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Enter your name',
                icon: Icons.person,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Enter your email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _passwordController,
                hintText: 'Enter your password',
                icon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                icon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Cousetombutton(
                      text: 'Sign Up',
                      icon: Icons.check,
                      onpressed: _signUp,
                    ),
              const SizedBox(height: 20),
              const Text(
                'Or ',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _signUpWithGoogle,
                child: Container(
                  // height: 50,
                  // width: 50,
                  child: Image.asset('assets/androidsu.png'), // Google icon
                ),
              ),
            ],
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
