import 'package:flutter/material.dart';

class DefaultPainter extends CustomPainter {
  final bool withBorder;
  DefaultPainter({this.withBorder = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
