import 'package:flutter/material.dart';

class Buildhandle extends StatefulWidget {
  const Buildhandle({super.key});

  @override
  State<Buildhandle> createState() => _BuildhandleState();
}

class _BuildhandleState extends State<Buildhandle> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 140.0),
      child: Divider(
        color: Colors.black,
        thickness: 4.0,
      ),
    );
  }
}
