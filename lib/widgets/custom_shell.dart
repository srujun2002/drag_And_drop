import 'package:drag_and_drop/widgets/custom_cards.dart';
import 'package:drag_and_drop/widgets/resize_menu_widget.dart';
import 'package:flutter/material.dart';

class custom_shells extends StatelessWidget {
  const custom_shells({
    super.key,
    required this.widget,
    required this.width,
    required this.name,
  });

  final ResizableCustomWidget widget;
  final double width;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Expanded(
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: widget.minWidth,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    color: Colors.grey[300],
                    child: GridView.count(
                      crossAxisCount: widget.crossAxisCount,
                      children: widget.components.map((component) {
                        return custom_cards(
                          item: component['name'] ?? '',
                          imagePath: component['imagePath'] ?? '',
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
