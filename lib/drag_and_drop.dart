import 'package:flutter/material.dart';

void main() {
  runApp(DragDropApp());
}

class DraggableItem extends StatefulWidget {
  final String label;
  final Offset initialPosition;
  final Function(DraggableItem) onSelected;

  const DraggableItem({
    required this.label,
    required this.initialPosition,
    required this.onSelected,
  });

  Offset get position => initialPosition;

  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  late Offset position;

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
        onTap: () => widget.onSelected(widget),
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
                position.dx + details.delta.dx, position.dy + details.delta.dy);
          });
        },
        child: Container(
          width: 100,
          height: 50,
          color: Colors.red,
          child: Center(
            child: Text(widget.label, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class DragDropApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DragDropScreen(),
    );
  }
}

class DragDropScreen extends StatefulWidget {
  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  List<DraggableItem> droppedItems = [];
  List<Connection> connections = [];
  List<List<DraggableItem>> history = [];
  int historyIndex = -1;
  DraggableItem? selectedItem;
  Connection? selectedConnection;

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

  void onItemDropped(String label, Offset position) {
    setState(() {
      if (label == "Bus") {
        if (selectedConnection == null) {
          selectedConnection = Connection(
              start: position, end: position, onMoved: updateConnection);
          connections.add(selectedConnection!);
        } else {
          selectedConnection = null;
        }
      } else {
        droppedItems.add(DraggableItem(
          label: label,
          initialPosition: position,
          onSelected: (item) {
            if (selectedItem == null) {
              selectedItem = item;
            } else {
              connections.add(Connection(
                  start: selectedItem!.position,
                  end: item.position,
                  onMoved: updateConnection));
              selectedItem = null;
            }
          },
        ));
      }
      saveState();
    });
  }

  void updateConnection(Connection connection, Offset newStart, Offset newEnd) {
    setState(() {
      connection.start = newStart;
      connection.end = newEnd;
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
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Draggable<String>(
                  data: "Box 1",
                  feedback: DraggingBox(label: "Box 1"),
                  child: SidebarItem(label: "Box 1"),
                  childWhenDragging:
                      Opacity(opacity: 0.5, child: SidebarItem(label: "Box 1")),
                ),
                Draggable<String>(
                  data: "Box 2",
                  feedback: DraggingBox(label: "Box 2"),
                  child: SidebarItem(label: "Box 2"),
                  childWhenDragging:
                      Opacity(opacity: 0.5, child: SidebarItem(label: "Box 2")),
                ),
                Draggable<String>(
                  data: "Bus",
                  feedback: DraggingBox(label: "Bus"),
                  child: SidebarItem(label: "Bus"),
                  childWhenDragging:
                      Opacity(opacity: 0.5, child: SidebarItem(label: "Bus")),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    onItemDropped(details.data, details.offset);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container();
                  },
                ),
                ...connections,
                ...droppedItems,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Connection extends StatefulWidget {
  Offset start;
  Offset end;
  final Function(Connection, Offset, Offset) onMoved;

  Connection({required this.start, required this.end, required this.onMoved});

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.start.dx,
      top: widget.start.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.start += details.delta;
            widget.end += details.delta;
          });
          widget.onMoved(widget, widget.start, widget.end);
        },
        child: CustomPaint(
          painter: ConnectionPainter(start: widget.start, end: widget.end),
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  ConnectionPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SidebarItem extends StatelessWidget {
  final String label;
  const SidebarItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      color: Colors.blue,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}

class DraggingBox extends StatelessWidget {
  final String label;
  const DraggingBox({required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue,
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
