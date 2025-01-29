import 'package:drag_and_drop/widgets/component_shape.dart';
import 'package:drag_and_drop/widgets/dragable_item.dart';
import 'package:drag_and_drop/widgets/resize_menu_widget.dart';
import 'package:flutter/material.dart';

class DragDropScreen extends StatefulWidget {
  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  List<DraggableItem> droppedItems = [];
  List<List<DraggableItem>> history = [];
  int historyIndex = -1;
  List<Map<String, String>> componentList = [
    {"name": "Diode", "imagePath": "assets\images\Capacitor.png"},
    {"name": "Transistor", "imagePath": "assets\images\Resistor.png"},
    {"name": "Resistor", "imagePath": "assets/images/resistor.png"},
    {"name": "Capacitor", "imagePath": "assets/images/capacitor.png"},
    {"name": "Inductor", "imagePath": "assets/images/inductor.png"},
    {"name": "Switch", "imagePath": "assets/images/switch.png"},
    {"name": "Battery", "imagePath": "assets/images/battery.png"},
    {"name": "LED", "imagePath": "assets/images/led.png"},
    {"name": "Motor", "imagePath": "assets/images/motor.png"},
    {"name": "Transformer", "imagePath": "assets/images/transformer.png"},
  ];

  final GlobalKey canvasKey = GlobalKey(); // Key for the canvas area

  void saveState() {
    if (historyIndex < history.length - 1) {
      history = history.sublist(0, historyIndex + 1);
    }
    history.add(List.from(droppedItems));
    historyIndex++;
  }

  void undo() {
    if (historyIndex > 0) {
      setState(() {
        historyIndex--;
        droppedItems = List.from(history[historyIndex]);
      });
    }
  }

  void redo() {
    if (historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        droppedItems = List.from(history[historyIndex]);
      });
    }
  }

  void onItemDropped(String label, Offset globalPosition, String imagePath) {
    RenderBox canvasBox =
        canvasKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition =
        canvasBox.globalToLocal(globalPosition); // Convert to local position

    setState(() {
      droppedItems.add(DraggableItem(
        label: label,
        initialPosition: localPosition,
        imagePath: imagePath,
      ));
      saveState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drag & Drop Canvas"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.undo),
          //   onPressed: undo,
          // ),
          // IconButton(
          //   icon: Icon(Icons.redo),
          //   onPressed: redo,
          // ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(width: 10),
          ResizableCustomWidget(
            // name: "",
            isRightExtendable: true,
            components: componentList,
          ),
          Expanded(
            child: Stack(
              key: canvasKey, // Assign the key to the canvas area
              children: [
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    onItemDropped(details.data, details.offset,
                        'assets\images\Capacitor.png');
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      color: Colors.grey[200], // Add background for the canvas
                    );
                  },
                ),
                ...droppedItems,
              ],
            ),
          ),
          // Image.asset('assets/images/Capacitor.png'),
          ResizableCustomWidget(
            name: "Shunt",
            isLeftExtendable: true,
            minWidth: 300,
            width: 100,
            crossAxisCount: 3,
            components: componentList,
          ),
        ],
      ),
    );
  }
}
