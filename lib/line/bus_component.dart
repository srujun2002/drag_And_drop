import 'package:flutter/material.dart';

class BusComponent extends StatefulWidget {
  final Offset initialPosition;

  const BusComponent({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  _BusComponentState createState() => _BusComponentState();
}

class _BusComponentState extends State<BusComponent> {
  late Offset position;
  double lineWidth = 50; // Initial line width

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
            position += details.delta; // Move bus component
          });
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left Resize Handle
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      lineWidth = (lineWidth - details.delta.dx).clamp(50, 300);
                      position =
                          Offset(position.dx + details.delta.dx, position.dy);
                    });
                  },
                  child: Container(
                    width: 10,
                    height: 20,
                    color: Colors.black,
                  ),
                ),

                // Extendable Line
                Container(
                  width: lineWidth,
                  height: 4,
                  color: Colors.black,
                ),

                // Right Resize Handle
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      lineWidth = (lineWidth + details.delta.dx).clamp(50, 300);
                    });
                  },
                  child: Container(
                    width: 10,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            // Bus Shape
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  "BUS",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
