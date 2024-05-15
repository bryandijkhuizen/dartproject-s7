import 'package:flutter/material.dart';

class AnimatedAngledBox extends StatefulWidget {
  @override
  _AnimatedAngledBoxState createState() => _AnimatedAngledBoxState();
}

class _AnimatedAngledBoxState extends State<AnimatedAngledBox> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(1.5, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation!,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 30), // Adjust top padding to move down
          child: CustomPaint(
            painter: AngledBoxPainter(),
            child: Container(
              height: 30, // Adjust height
              width: MediaQuery.of(context).size.width * 1, // Adjust width
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Text(
                'T20, D20',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AngledBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFCD0612)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.6, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
