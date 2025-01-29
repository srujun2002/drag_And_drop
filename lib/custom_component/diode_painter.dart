import 'package:flutter/material.dart';

class DiodePainter extends CustomPainter {
  final bool withBorder;
  DiodePainter({this.withBorder = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path trianglePath = Path();
    trianglePath.moveTo(size.width * 0.2, size.height * 0.5);
    trianglePath.lineTo(size.width * 0.7, size.height * 0.2);
    trianglePath.lineTo(size.width * 0.7, size.height * 0.8);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
