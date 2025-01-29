import 'package:flutter/material.dart';

class TransistorPainter extends CustomPainter {
  final bool withBorder;
  TransistorPainter({this.withBorder = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
