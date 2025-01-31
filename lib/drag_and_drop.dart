import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  List<DraggableContainer> placedContainers = [];
  List<ConnectionLine> connections = [];
  DraggableContainer? selectedContainer;

  void addContainer(DraggableContainer container, Offset position) {
    setState(() {
      placedContainers.add(container.copyWith(position: position));
    });
  }

  void connectContainers(DraggableContainer container) {
    if (selectedContainer != null && selectedContainer != container) {
      setState(() {
        connections.add(ConnectionLine(
          start: selectedContainer!.position,
          end: container.position,
        ));
        print('Connected: ${selectedContainer!.id} -> ${container.id}');
        selectedContainer = null;
      });
    } else {
      setState(() {
        selectedContainer = container;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidePanel(
            isLeft: true,
            onDragStart: (container) =>
                addContainer(container, Offset(100, 300)),
          ),
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedContainer = null),
                  child: Container(color: Colors.grey[200]),
                ),
                ...connections.map((line) => CustomPaint(
                      painter: LinePainter(line.start, line.end),
                    )),
                ...placedContainers.map((container) => Positioned(
                      left: container.position.dx,
                      top: container.position.dy,
                      child: GestureDetector(
                        onTap: () => connectContainers(container),
                        child: ContainerWidget(
                          container: container,
                          isSelected: selectedContainer == container,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SidePanel(
            isLeft: false,
            onDragStart: (container) =>
                addContainer(container, Offset(500, 300)),
          ),
        ],
      ),
    );
  }
}

class SidePanel extends StatelessWidget {
  final bool isLeft;
  final Function(DraggableContainer) onDragStart;

  SidePanel({required this.isLeft, required this.onDragStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: isLeft ? Colors.blue[100] : Colors.green[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final container = DraggableContainer(
            id: '${isLeft ? "L" : "R"}$index',
            color: Colors.primaries[index],
            position: Offset.zero,
          );
          return Draggable(
            data: container,
            feedback: ContainerWidget(container: container),
            child: ContainerWidget(container: container),
            onDragStarted: () => onDragStart(container),
          );
        }),
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final DraggableContainer container;
  final bool isSelected;

  ContainerWidget({required this.container, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: container.color,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        container.id,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start, end;
  LinePainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DraggableContainer {
  final String id;
  final Color color;
  final Offset position;

  DraggableContainer(
      {required this.id, required this.color, required this.position});

  DraggableContainer copyWith({Offset? position}) {
    return DraggableContainer(
        id: id, color: color, position: position ?? this.position);
  }
}

class ConnectionLine {
  final Offset start, end;
  ConnectionLine({required this.start, required this.end});
}
