import 'package:drag_and_drop/line/dragable_line.dart';
import 'package:drag_and_drop/widgets/dragable_item.dart';
import 'package:drag_and_drop/widgets/resize_menu_widget.dart';
import 'package:flutter/material.dart';

class DragDropScreen extends StatefulWidget {
  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  List<DraggableItem> droppedItems = [];
  List<DraggableLine> lines = [];
  List<List<DraggableItem>> history = [];
  int historyIndex = -1;
  List<Map<String, String>> componentList = [
    {"name": "Capacitor", "imagePath": "assets/images/Capacitor.png"},
    {"name": "Diode", "imagePath": "assets/images/Tunnel Diode.png"},
    {"name": "Resistor", "imagePath": "assets/images/resistor.png"},
  ];

  final GlobalKey canvasKey = GlobalKey();

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

  void addLine(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    setState(() {
      lines.add(DraggableLine(initialPosition: localPosition));
    });
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
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: undo,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: redo,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              addLine(Offset(100, 200));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(width: 10),
          ResizableCustomWidget(
            isRightExtendable: true,
            components: componentList,
          ),
          Expanded(
            child: SafeArea(
              child: Stack(
                key: canvasKey,
                children: [
                  Positioned.fill(
                    child: DragTarget<String>(
                      onAcceptWithDetails: (details) {
                        onItemDropped(
                          details.data,
                          details.offset,
                          componentList.firstWhere((element) =>
                                  element["name"] ==
                                  details.data)["imagePath"] ??
                              '',
                        );
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          color: Colors.grey[200],
                        );
                      },
                    ),
                  ),
                  ...droppedItems.map((item) {
                    return Positioned(
                      left: item.initialPosition.dx,
                      top: item.initialPosition.dy,
                      child: item,
                    );
                  }).toList(),
                  ...lines.map((line) {
                    return Positioned(
                      left: line.initialPosition.dx,
                      top: line.initialPosition.dy,
                      child: line,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
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
