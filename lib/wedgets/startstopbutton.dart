import 'package:flutter/material.dart';
import 'package:flutter_application/wedgets/messagehandler.dart';

class StartStopButton extends StatefulWidget {
  final VoidCallback onStartTap;
  final VoidCallback onStopTap;
  final bool isConnected;

  const StartStopButton({
    Key? key,
    required this.onStartTap,
    required this.onStopTap,
    required this.isConnected,
  }) : super(key: key);

  @override
  _StartStopButtonState createState() => _StartStopButtonState();
}

class _StartStopButtonState extends State<StartStopButton>
    with SingleTickerProviderStateMixin {
  bool isStart = true;
  late MessageHandler _messageHandler;
  @override
  void initState() {
    super.initState();
    _messageHandler = MessageHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isConnected) {
          setState(() {
            isStart = !isStart;
            if (isStart) {
              widget.onStartTap();
            } else {
              widget.onStopTap();
            }
          });
        } else {
          _messageHandler.showMessage('Not connected to Bluetooth');
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 30,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
          ),
          // Circular border with dashed effect
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: DashedCirclePainter(),
            ),
          ),
          // Active state text
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 700),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: Text(
                isStart ? 'START' : 'STOP',
                key: ValueKey<bool>(isStart),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Inactive state text
          Positioned(
            top: 60,
            child: Opacity(
              opacity: 0.3,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  isStart ? 'STOP' : 'START',
                  key: ValueKey<bool>(isStart),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double gap = 4;
    final double dashWidth = 2;
    final double circumference = 2 * 3.141592653589793 * radius;
    final int dashCount = (circumference / (dashWidth + gap)).floor();
    final double adjustedDashWidth =
        (circumference - (dashCount * gap)) / dashCount;

    for (int i = 0; i < dashCount; ++i) {
      final double startAngle = (i * (adjustedDashWidth + gap)) / radius;
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        adjustedDashWidth / radius,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
