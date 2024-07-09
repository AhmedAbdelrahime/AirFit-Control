import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/auth/useridscreen.dart';
import 'package:flutter_application/screens/carcontrol.dart';
import 'package:flutter_application/screens/getstart.dart';
import 'package:flutter_application/screens/homescreen/homescreen.dart';
import 'package:flutter_application/screens/splashscareen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // If user is authenticated, show the profile view
              return HomeScreen();
              // HomeScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return SplashScreenPage();
              //   Welcomepage  SplashScreenPage
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
