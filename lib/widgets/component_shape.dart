// import 'package:drag_and_drop/custom_component/default_painter.dart';
// import 'package:drag_and_drop/custom_component/diode_painter.dart';
// import 'package:drag_and_drop/custom_component/resistor_painter.dart';
// import 'package:drag_and_drop/custom_component/transistor_painter.dart';
// import 'package:drag_and_drop/drag_and_drop.dart';
// import 'package:flutter/material.dart';

// class ComponentShape extends StatelessWidget {
//   final String label;
//   final bool withBorder;
//   const ComponentShape({required this.label, this.withBorder = false});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(50, 50),
//       painter: _getPainter(label, withBorder),
//     );
//   }

//   CustomPainter _getPainter(String label, bool withBorder) {
//     switch (label) {
//       case "Diode":
//         return DiodePainter(withBorder: withBorder);
//       case "Transistor":
//         return TransistorPainter(withBorder: withBorder);
//       case "Resistor":
//         return ResistorPainter(withBorder: withBorder);
//       // case "Capacitor":
//       //   return CapacitorPainter(withBorder: withBorder);
//       // case "Inductor":
//       //   return InductorPainter(withBorder: withBorder);
//       default:
//         return DefaultPainter(withBorder: withBorder);
//     }
//   }
// }
