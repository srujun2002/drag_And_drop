import 'package:flutter/material.dart';

class CustomCards extends StatelessWidget {
  final String item;
  final String imagePath;

  const CustomCards({required this.imagePath, required this.item, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Draggable<String>(
        data: item,
        feedback: SizedBox(
          width: 50,
          height: 50,
          child: Container(
            color: item == "Line" ? Colors.black : Colors.white,
            child: item == "Line"
                ? Container(
                    width: 50,
                    height: 4,
                    color: Colors.black) // Show Line preview
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        child: Column(
          children: [
            item == "Line"
                ? Container(width: 50, height: 4, color: Colors.black)
                : Image.asset(imagePath, width: 50, height: 50),
            Text(item, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
