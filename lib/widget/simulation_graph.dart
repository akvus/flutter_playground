import 'package:flutter/material.dart';

class SimulationGraph extends StatelessWidget {
  final Simulation simulation;
  final double maxValue;

  const SimulationGraph({
    super.key,
    required this.simulation,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: SimulationPainter(simulation, maxValue),
      );
}

class SimulationPainter extends CustomPainter {
  final Simulation simulation;
  late final double _yDivisionFactor;

  final Paint _backgroundPaint = Paint()..color = Colors.grey;
  final Paint _xAxisPaint = Paint()..color = Colors.red;
  final Paint _pathPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  SimulationPainter(this.simulation, double maxValue) {
    _yDivisionFactor = 100 / maxValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // should investigate why ~111% is the max, but I'm lazy
    final yDivision = 111 / size.height;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _backgroundPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      _xAxisPaint,
    );

    final path = Path();
    path.moveTo(0, 0);

    double t = 0.0;
    for (int x = 0; x < size.width; x++, t += 0.1) {
      final dt = t.toDouble();
      if (simulation.isDone(dt)) break;

      final y = simulation.x(dt) * _yDivisionFactor * yDivision;
      path.lineTo(x.toDouble(), y);
    }

    canvas.drawPath(path, _pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO optimize
    return true;
  }
}
