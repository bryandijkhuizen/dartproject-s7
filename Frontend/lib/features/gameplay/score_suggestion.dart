import 'package:flutter/material.dart';

class AnimatedAngledBox extends StatefulWidget {
  final bool isPlayer1;

  const AnimatedAngledBox({super.key, required this.isPlayer1});

  @override
  AnimatedAngledBoxState createState() => AnimatedAngledBoxState();
}

class AnimatedAngledBoxState extends State<AnimatedAngledBox> with SingleTickerProviderStateMixin {
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
      begin: widget.isPlayer1 ? const Offset(-1.5, 0.0) : const Offset(1.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));
  }

  void show() {
    _controller!.forward();
  }

  void hide() {
    _controller!.reverse();
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
        alignment: widget.isPlayer1 ? Alignment.centerLeft : Alignment.centerRight,
        child: CustomPaint(
          painter: AngledBoxPainter(),
          child: Container(
            height: 30, // Adjust height
            width: MediaQuery.of(context).size.width * 0.5, // Adjust width
            alignment: widget.isPlayer1 ? Alignment.centerLeft : Alignment.centerRight,
            padding: EdgeInsets.only(left: widget.isPlayer1 ? 10 : 0, right: widget.isPlayer1 ? 0 : 10),
            child: const Text(
              'T20, D20',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
      ..color = const Color(0xFFCD0612)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width * 0.7, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
