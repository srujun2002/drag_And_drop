import 'package:flutter/material.dart';
import 'dart:math';

class DraggableLine extends StatefulWidget {
  final Offset initialPosition;

  const DraggableLine({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  _DraggableLineState createState() => _DraggableLineState();
}

class _DraggableLineState extends State<DraggableLine> {
  late Offset position;
  double width = 100;
  double angle = 0.0;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  /// Calculates the position of a point based on rotation
  Offset _getRotatedOffset(double xOffset) {
    double x = position.dx + cos(angle) * xOffset;
    double y = position.dy + sin(angle) * xOffset;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Labels (Start, Middle, End)
            Positioned(
              left: _getRotatedOffset(-width / 2).dx - position.dx,
              top: _getRotatedOffset(-width / 2).dy - position.dy - 20,
              child: Transform.rotate(
                angle: angle,
                child: Text("Start",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              left: _getRotatedOffset(0).dx - position.dx,
              top: _getRotatedOffset(0).dy - position.dy - 20,
              child: Transform.rotate(
                angle: angle,
                child: Text("Middle",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              left: _getRotatedOffset(width / 2).dx - position.dx,
              top: _getRotatedOffset(width / 2).dy - position.dy - 20,
              child: Transform.rotate(
                angle: angle,
                child: Text("End",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),

            // Line with rotation
            Transform.rotate(
              angle: angle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Resize Handle
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        width = (width - details.delta.dx).clamp(20, 300);
                        position =
                            Offset(position.dx + details.delta.dx, position.dy);
                      });
                    },
                    child: Container(width: 10, height: 20, color: Colors.blue),
                  ),

                  // The Line
                  Container(width: width, height: 4, color: Colors.black),

                  // Right Resize Handle
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        width = (width + details.delta.dx).clamp(20, 300);
                      });
                    },
                    child: Container(width: 10, height: 20, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // Rotation Handle
            Positioned(
              left: width / 2 - 10,
              top: 10,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    angle += details.delta.dy * 0.01; // Adjust rotation
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child:
                      Icon(Icons.rotate_right, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
