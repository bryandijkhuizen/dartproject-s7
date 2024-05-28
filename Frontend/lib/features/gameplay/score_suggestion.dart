import 'package:flutter/material.dart';

class AnimatedAngledBox extends StatelessWidget {
  final bool isPlayer1;
  final String suggestion;

  const AnimatedAngledBox({
    super.key,
    required this.isPlayer1,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isPlayer1 ? Alignment.centerLeft : Alignment.centerRight,
      child: CustomPaint(
        painter: AngledBoxPainter(isPlayer1: isPlayer1),
        child: Container(
          height: 30, // Adjust height
          alignment: isPlayer1 ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.only(left: isPlayer1 ? 10 : 0, right: isPlayer1 ? 0 : 10),
          child: Text(
            suggestion,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AngledBoxPainter extends CustomPainter {
  final bool isPlayer1;

  AngledBoxPainter({required this.isPlayer1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C4789)
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isPlayer1) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width * 0.35, 0)
        ..lineTo(size.width * 0.25, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width * 0.65, 0)
        ..lineTo(size.width * 0.75, size.height)
        ..lineTo(size.width, size.height)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
