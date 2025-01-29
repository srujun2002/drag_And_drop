import 'package:drag_and_drop/widgets/component_shape.dart';
import 'package:flutter/material.dart';

class ResizableCustomWidget extends StatefulWidget {
  const ResizableCustomWidget({
    this.name = "tetegt",
    super.key,
    this.minWidth = 50,
    this.width = 50,
    this.crossAxisCount = 1,
    required this.componentNames,
    this.isRightExtendable = false,
    this.isLeftExtendable = false,
  });
  final String name;
  final double width;
  final double minWidth;
  final bool isRightExtendable;
  final bool isLeftExtendable;
  final int crossAxisCount;
  final List<String> componentNames;

  @override
  _ResizableCustomWidgetState createState() => _ResizableCustomWidgetState();
}

class _ResizableCustomWidgetState extends State<ResizableCustomWidget> {
  late double width;

  @override
  void initState() {
    super.initState();
    width = widget.width; // Initialize width with the provided value
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
                    width -=
                        details.delta.dx; // Decrease width on drag to the left
                    width = width.clamp(
                        widget.minWidth,
                        MediaQuery.of(context)
                            .size
                            .width); // Set min/max bounds
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeft,
                  child: Container(
                    width: 8, // Resizable handle width
                    color:
                        Colors.blue.withOpacity(0.5), // Resizable handle color
                  ),
                ),
              ),
            ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.name.isNotEmpty)
                Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Text(widget.name),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ],
                    )),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: widget.minWidth,
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    color: Colors.grey[300],
                    child: GridView.count(
                      crossAxisCount: widget.crossAxisCount,
                      children: widget.componentNames.map((item) {
                        return Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: custom_cards(
                                  item: item,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.isLeftExtendable)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    width -=
                        details.delta.dx; // Decrease width on drag to the left
                    width = width.clamp(
                        widget.minWidth,
                        MediaQuery.of(context)
                            .size
                            .width); // Set min/max bounds
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeft,
                  child: Container(
                    width: 1, // Resizable handle width
                    color:
                        Colors.black.withOpacity(0.5), // Resizable handle color
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class custom_cards extends StatelessWidget {
  const custom_cards({
    required this.item,
    super.key,
  });
  final String item;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Draggable<String>(
        data: item,
        feedback: SizedBox(
          width: 50,
          height: 50,
          child: ComponentShape(label: item, withBorder: false),
        ),
        child: SizedBox(
          width: 50,
          height: 50,
          child: ComponentShape(label: item, withBorder: false),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: SizedBox(
            width: 50,
            height: 50,
            child: ComponentShape(label: item, withBorder: false),
          ),
        ),
      ),
    );
  }
}
