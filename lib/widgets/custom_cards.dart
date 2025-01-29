import 'package:drag_and_drop/custom_component/component_shape.dart';
import 'package:flutter/material.dart';

class custom_cards extends StatelessWidget {
  const custom_cards({
    required this.imagePath,
    required this.item,
    super.key,
  });
  final String item;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Draggable<String>(
        data: item,
        feedback: SizedBox(
          width: 20,
          height: 30,
          child: ComponentShape(
            componentName: item,
            imagePath: imagePath,
          ),
        ),
        child: SizedBox(
          width: 20,
          height: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ComponentShape(
                componentName: item,
                imagePath: imagePath,
              ),
              Text(item, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: SizedBox(
            width: 20,
            height: 20,
            child: ComponentShape(
              componentName: item,
              imagePath: imagePath,
            ),
          ),
        ),
      ),
    );
  }
}
