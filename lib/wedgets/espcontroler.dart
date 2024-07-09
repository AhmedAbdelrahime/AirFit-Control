import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ESP32Controller {
  BluetoothConnection? _connection;
  final MessageHandler _messageHandler;

  ESP32Controller(this._connection, this._messageHandler);

  Future<void> sendCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      try {
        _sendData(command);
        _messageHandler.showMessage("Command sent: $command", Colors.green);
      } catch (e) {
        _messageHandler.showMessage("Failed to send command: $e", Colors.red);
      }
    } else {
      _messageHandler.showMessage("Not connected to any device", Colors.red);
    }
  }

  void _sendData(String data) {
    _connection?.output.add(ascii.encode(data));
  }
}
