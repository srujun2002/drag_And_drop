import 'package:drag_and_drop/widgets/custom_cards.dart';
import 'package:drag_and_drop/widgets/resize_menu_widget.dart';
import 'package:flutter/material.dart';

class CustomShell extends StatelessWidget {
  const CustomShell({
    super.key,
    required this.widget,
    required this.width,
    required this.name,
    required this.components,
  });

  final ResizableCustomWidget widget;
  final double width;
  final String name;
  final List<Map<String, String>> components;

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
                      children: components.map((component) {
                        return CustomCards(
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
