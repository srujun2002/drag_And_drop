import 'package:drag_and_drop/line/line_painter.dart';
import 'package:flutter/material.dart';

class DraggableLine extends StatefulWidget {
  final Offset initialPosition;

  const DraggableLine({super.key, required this.initialPosition});

  @override
  _DraggableLineState createState() => _DraggableLineState();
}

class _DraggableLineState extends State<DraggableLine> {
  late Offset start;
  late Offset end;

  @override
  void initState() {
    super.initState();
    start = widget.initialPosition;
    end = Offset(start.dx + 100, start.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: start.dx,
      top: start.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            start = Offset(
                start.dx + details.delta.dx, start.dy + details.delta.dy);
            end = Offset(end.dx + details.delta.dx, end.dy + details.delta.dy);
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(300, 300),
              painter: LinePainter(start: start, end: end),
            ),
            _resizeHandle(isStart: true),
            _resizeHandle(isStart: false),
          ],
        ),
      ),
    );
  }

  Widget _resizeHandle({required bool isStart}) {
    return Positioned(
      left: isStart ? start.dx - 10 : end.dx - 10,
      top: isStart ? start.dy - 10 : end.dy - 10,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (isStart) {
              start = Offset(
                  start.dx + details.delta.dx, start.dy + details.delta.dy);
            } else {
              end =
                  Offset(end.dx + details.delta.dx, end.dy + details.delta.dy);
            }
          });
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
