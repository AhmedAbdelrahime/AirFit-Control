import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ESP32DataReceiver {
  BluetoothConnection? _connection;
  final Function(double) onDataReceived;
  final Function(String, Color) onMessage;

  ESP32DataReceiver(this.onDataReceived, this.onMessage);

  void setConnection(BluetoothConnection? connection) {
    _connection = connection;
    if (_connection != null && _connection!.isConnected) {
      _startListening();
    }
  }

  void _startListening() {
    _connection?.input?.listen((Uint8List data) {
      String receivedString = String.fromCharCodes(data);
      double receivedValue = double.tryParse(receivedString) ?? 0.0;
      onDataReceived(receivedValue);
    }).onDone(() {
      if (_connection?.isConnected ?? false) {
        onMessage('Disconnected from device', Colors.orange);
      }
    });
  }
}
