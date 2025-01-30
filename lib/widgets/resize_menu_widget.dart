import 'package:drag_and_drop/line/bus_component.dart';
import 'package:drag_and_drop/widgets/custom_cards.dart';
import 'package:drag_and_drop/widgets/custom_shell.dart';
import 'package:flutter/material.dart';

class ResizableCustomWidget extends StatefulWidget {
  const ResizableCustomWidget({
    this.name = "tetegt",
    super.key,
    this.minWidth = 50,
    this.width = 50,
    this.crossAxisCount = 1,
    required this.components,
    this.isRightExtendable = false,
    this.isLeftExtendable = false,
  });
  final String name;
  final double width;
  final double minWidth;
  final bool isRightExtendable;
  final bool isLeftExtendable;
  final int crossAxisCount;
  final List<Map<String, String>> components;

  @override
  _ResizableCustomWidgetState createState() => _ResizableCustomWidgetState();
}

class _ResizableCustomWidgetState extends State<ResizableCustomWidget> {
  late double width;

  @override
  void initState() {
    super.initState();
    width = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          if (widget.isRightExtendable)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    width -= details.delta.dx;
                    width = width.clamp(
                        widget.minWidth, MediaQuery.of(context).size.width);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeft,
                  child: Container(
                    width: 8,
                    color: Colors.blue.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          Card(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                CustomShell(
                  components: [
                    {
                      "name": "Capacitor",
                      "imagePath": "assets/images/Capacitor.png"
                    },
                    {
                      "name": "Diode",
                      "imagePath": "assets/images/Tunnel Diode.png"
                    },
                    {
                      "name": "Resistor",
                      "imagePath": "assets/images/resistor.png"
                    },
                  ],
                  widget: widget,
                  width: width,
                  name: "Shunts",
                ),
                CustomShell(
                  components: [
                    {
                      "name": "Capacitor",
                      "imagePath": "assets/images/Capacitor.png"
                    },
                    {
                      "name": "Diode",
                      "imagePath": "assets/images/Tunnel Diode.png"
                    },
                    {
                      "name": "Resistor",
                      "imagePath": "assets/images/resistor.png"
                    },
                  ],
                  widget: widget,
                  width: width,
                  name: 'Series',
                ),
                // BusComponent(initialPosition: Offset(100, 100)),
                CustomShell(
                  components: [
                    {
                      "name": "Capacitor",
                      "imagePath": "assets/images/Capacitor.png"
                    },
                    // {
                    //   "name": "Diode",
                    //   "imagePath": "assets/images/Tunnel Diode.png"
                    // },
                    // {
                    //   "name": "Resistor",
                    //   "imagePath": "assets/images/resistor.png"
                    // },
                  ],
                  widget: widget,
                  width: width,
                  name: 'Transformers',
                ),
              ],
            ),
          ),
          if (widget.isLeftExtendable)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    width -= details.delta.dx;
                    width = width.clamp(
                        widget.minWidth, MediaQuery.of(context).size.width);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeft,
                  child: Container(
                    width: 1,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
