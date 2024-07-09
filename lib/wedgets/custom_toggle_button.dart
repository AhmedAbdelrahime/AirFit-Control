import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> buttonLabels;
  final ValueChanged<int> onChanged;
  final double buttonSize;
  final double fontSize;

  const CustomToggleButton({
    super.key,
    required this.buttonLabels,
    required this.onChanged,
    this.buttonSize = 60,
    this.fontSize = 20,
  });

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _selectButton(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onChanged(selectedIndex);
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = widget.buttonSize;
    double fontSize = widget.fontSize;

    return SingleChildScrollView(
      child: Container(
        width: buttonSize * 1.25,
        height: buttonSize * widget.buttonLabels.length * 1.25,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(90),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.buttonLabels.asMap().entries.map((entry) {
            int index = entry.key;
            String label = entry.value;
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => _selectButton(index),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CirclePainter(_animation.value),
                          );
                        },
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[850],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3),
                          spreadRadius: isSelected ? 5 : 3,
                          blurRadius: isSelected ? 10 : 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      left: -buttonSize * 0.8,
                      child: const Icon(Icons.arrow_left,
                          color: Colors.white, size: 70),
                    ),
                  if (isSelected)
                    Positioned(
                      right: -buttonSize * 0.8,
                      child: const Icon(Icons.arrow_right,
                          color: Colors.white, size: 70),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // final Paint paint = Paint()
    // ..color = Colors.blue.withOpacity(0.9)
    // ..style = PaintingStyle.stroke
    // ..strokeWidth = 2;

    // Draw circles with inner shadow
    // for (int i = 1; i <= 7; i++) {
    //   double radius = (size.width / 1.5) * (progress + i * 0.1);
    //   if (i == 1) {
    //     paint
    //       ..color = Colors.white.withOpacity(0.2)
    //       ..maskFilter = MaskFilter.blur(BlurStyle.inner, 10);
    //   } else {
    //     paint.maskFilter = null;
    //   }
    //   canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
