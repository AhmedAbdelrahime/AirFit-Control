import 'package:flutter/material.dart';
import 'package:flutter_application/screens/homescreen/bulddragblesheet/buildHandle.dart';
import 'package:flutter_application/screens/homescreen/bulddragblesheet/buildmalcontroltitle.dart';
import 'package:flutter_application/screens/homescreen/bulddragblesheet/buildmanualcontrolboutton.dart';

class Builddraggablesheet extends StatefulWidget {
  const Builddraggablesheet({super.key});

  @override
  State<Builddraggablesheet> createState() => _BuilddraggablesheetState();
}

class _BuilddraggablesheetState extends State<Builddraggablesheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.13,
      minChildSize: 0.13,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.vertical(top: Radius.circular(60.0)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(10.0),
            children: [
              Buildhandle(),
              Buildmalcontroltitle(),
              // _buildDescription(),
              Buildmanualcontrolboutton(),
            ],
          ),
        );
      },
    );
  }
}
