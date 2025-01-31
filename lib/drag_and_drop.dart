import 'package:flutter/material.dart';

void main() {
  runApp((MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Component Canvas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CanvasScreen(),
    );
  }
}

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final List<Connection> connections = [];
  final List<List<Connection>> undoStack = [];
  final List<List<Connection>> redoStack = [];
  PositionedComponent? firstSelected;

  void handleComponentTap(PositionedComponent component) {
    setState(() {
      if (firstSelected == null) {
        firstSelected = component;
      } else {
        if (firstSelected != component) {
          undoStack.add(List.from(connections));
          redoStack.clear();
          connections.add(Connection(firstSelected!, component));
          print('Connected: ${firstSelected!.name} -> ${component.name}');
        }
        firstSelected = null;
      }
    });
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      setState(() {
        redoStack.add(List.from(connections));
        connections.clear();
        connections.addAll(undoStack.removeLast());
      });
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        undoStack.add(List.from(connections));
        connections.clear();
        connections.addAll(redoStack.removeLast());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Component Canvas'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: undo),
          IconButton(icon: const Icon(Icons.redo), onPressed: redo),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: const ComponentPanel(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                const CanvasArea(),
                ...connections.map((c) => c.buildConnection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComponentPanel extends StatelessWidget {
  const ComponentPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // final components = [
    //   'Component A',
    //   'Component B',
    //   'Component C',
    //   'Component D',
    //   'Component E',
    //   'Component F'
    // ];
    final components = [
      {'id': 'A', 'name': 'Component A', 'image': 'assets/component_a.png'},
      {'id': 'B', 'name': 'Component B', 'image': 'assets/component_b.png'},
      {'id': 'C', 'name': 'Component C', 'image': 'assets/component_c.png'},
      {'id': 'D', 'name': 'Component D', 'image': 'assets/component_d.png'},
      {'id': 'E', 'name': 'Component E', 'image': 'assets/component_e.png'},
      {'id': 'F', 'name': 'Component F', 'image': 'assets/component_f.png'}
    ];

    return ListView.builder(
      itemCount: components.length,
      itemBuilder: (context, index) {
        return Draggable<String>(
          data: components[index]['id'],
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blueAccent,
              child: Text(components[index]['name'].toString(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(components[index]['name'].toString()),
              leading: Image.asset(components[index]['image'].toString()),
            ),
          ),
        );
      },
    );
  }
}

class CanvasArea extends StatefulWidget {
  const CanvasArea({super.key});

  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  final List<Widget> _placedComponents = [];

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        setState(() {
          final offset = details.offset;
          _placedComponents.add(PositionedComponent(
              name: details.data, initialX: offset.dx, initialY: offset.dy));
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: _placedComponents,
        );
      },
    );
  }
}

class PositionedComponent extends StatefulWidget {
  final String name;
  double initialX;
  final double initialY;

  @override
  _PositionedComponentState createState() => _PositionedComponentState();

  double get x => _state?.x ?? initialX;
  double get y => _state?.y ?? initialY;

  _PositionedComponentState? _state;

  PositionedComponent(
      {super.key,
      required this.name,
      required this.initialX,
      required this.initialY});
}

class _PositionedComponentState extends State<PositionedComponent> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    x = widget.initialX;
    y = widget.initialY;
    widget._state = this;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          context
              .findAncestorStateOfType<_CanvasScreenState>()
              ?.handleComponentTap(widget);
        },
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.blue,
          child: Text(widget.name, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class Connection {
  final PositionedComponent start;
  final PositionedComponent end;

  Connection(this.start, this.end);

  Widget buildConnection() {
    return CustomPaint(
      painter: ConnectionPainter(start, end),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final PositionedComponent start;
  final PositionedComponent end;

  ConnectionPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(start.x, start.y), Offset(end.x, end.y), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
