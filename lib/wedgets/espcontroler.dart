import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ESP32Controller {
  final BluetoothConnection? _connection;
  final MessageHandler _messageHandler;

  ESP32Controller(this._connection, this._messageHandler);

  Future<void> sendCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      try {
        _sendData(command);
        String message = _getMessageForCommand(command);
        _messageHandler.showMessage(message, Colors.green);
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

  String _getMessageForCommand(String command) {
    switch (command) {
      case 'CL':
        return "Car locked successfully.";
      case 'CO':
        return "Car unlocked successfully.";
      case 'VO':
        return "Vehicle ignition turned on.";
      case 'VF':
        return "Vehicle ignition turned off.";
      case 'AO':
        return "Air conditioning turned on.";
      case 'AF':
        return "Air conditioning turned off.";
      case 'SO':
        return "Eco mode activated successfully.";
      case 'SF':
        return "Eco mode deactivated.";
      case 'RU':
        return "Rear suspension lifted.";
      case 'RD':
        return "Rear suspension lowered.";
      case 'S':
        return "Air suspension adjustments stopped.";
      case 'FRU':
        return "Front and rear suspension lifted.";
      case 'FRD':
        return "Front and rear suspension lowered.";
      case 'FU':
        return "Front suspension lifted.";
      case 'FD':
        return "Front suspension lowered.";
      case 'H':
        return "Vehicle set to High mode.";
      case 'R':
        return "Vehicle set to Ride mode.";
      case 'L':
        return "Vehicle set to Low mode.";
      case 'P':
        return "Vehicle set to Park mode.";
      case 'E':
        return "PSI tank reset successfully.";
      case 'HO':
        return "Pressure reading turned on.";
      case 'HF':
        return "Pressure reading turned off.";
      case 'PO':
        return "Height saving mode activated.";
      case 'PF':
        return "Height saving mode deactivated.";

      default:
        return "Command sent: $command";
    }
  }
}
