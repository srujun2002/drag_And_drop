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
  List<String> componentList = [
    "Diode",
    "Transistor",
    "Resistor",
    "Capacitor",
    "Inductor",
    "Switch",
    "Battery",
    "LED",
    "Motor",
    "Transformer"
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

  void onItemDropped(String label, Offset globalPosition) {
    RenderBox canvasBox =
        canvasKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition =
        canvasBox.globalToLocal(globalPosition); // Convert to local position

    setState(() {
      droppedItems
          .add(DraggableItem(label: label, initialPosition: localPosition));
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
            componentNames: componentList,
          ),
          Expanded(
            child: Stack(
              key: canvasKey, // Assign the key to the canvas area
              children: [
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    onItemDropped(details.data, details.offset);
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
          ResizableCustomWidget(
            name: "Shunt",
            isLeftExtendable: true,
            minWidth: 150,
            width: 100,
            componentNames: componentList,
            crossAxisCount: 3,
          ),
        ],
      ),
    );
  }
}
