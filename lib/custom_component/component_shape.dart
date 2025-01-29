import 'package:flutter/material.dart';

class ComponentShape extends StatelessWidget {
  final String imagePath;
  final String componentName;
  const ComponentShape(
      {required this.imagePath, required this.componentName, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 50,
          height: 50,
          color: Colors.grey,
          child: Center(
            child: Text(
              componentName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
