import 'package:drag_and_drop/custom_component/component_shape.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flutter/material.dart';

class DraggableItem extends StatefulWidget {
  final String label;
  final String imagePath;
  Offset initialPosition;

  DraggableItem(
      {required this.label,
      required this.initialPosition,
      required this.imagePath});

  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  late Offset position;
  double rotationAngle = 0.0;
  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void rotateComponent() {
    setState(() {
      // Rotate 90 degrees each time the component is tapped
      rotationAngle += 90.0;
      if (rotationAngle == 360.0) {
        rotationAngle = 0.0; // Reset to 0 degrees after a full rotation
      }
    });
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
        onDoubleTap: () {
          rotateComponent();
        },
        child: Transform.rotate(
          angle: rotationAngle * (3.14 / 180),
          child: SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {},
              child: ComponentShape(
                imagePath: widget.imagePath,
                componentName: widget.label,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
