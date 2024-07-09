import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application/screens/getstart.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Make _controller late-initialized
  late Animation<double> _animation; // Make _animation late-initialized

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    startSplashScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 8);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Welcomepage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: FadeIn(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  "assets/whitelogo.png",
                  width: 400.0,
                  height: 200.0,
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                duration: Duration(seconds: 2),
                delay: Duration(seconds: 1),
                child: Text(
                  'The Ultimate Air Suspension Control',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
