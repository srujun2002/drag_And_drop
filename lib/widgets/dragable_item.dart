import 'package:drag_and_drop/widgets/component_shape.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flutter/material.dart';

class DraggableItem extends StatefulWidget {
  final String label;
  Offset initialPosition;

  DraggableItem({required this.label, required this.initialPosition});

  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
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
        child: SizedBox(
          width: 50,
          height: 50,
          child: ComponentShape(label: widget.label, withBorder: false),
        ),
      ),
    );
  }
}
