import 'dart:math';

import 'package:flutter/material.dart';

class ConnectionPainterSibling extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final int arrowSize = 25;

  ConnectionPainterSibling({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the main line
    canvas.drawLine(start, end, paint);

    // Calculate the angle of the line
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);

    // Arrowhead size
    const double arrowLength = 10.0;
    const double arrowAngle = pi / 6; // 30 degrees

    // Calculate the points for the arrowhead
    final Offset arrowPoint1 = Offset(
      end.dx - (25 * cos(angle)) - arrowLength * cos(angle - arrowAngle),
      end.dy - (25 * sin(angle)) - arrowLength * sin(angle - arrowAngle),
    );

    final Offset arrowPoint2 = Offset(
      end.dx - (25 * cos(angle)) - arrowLength * cos(angle + arrowAngle),
      end.dy - (25 * sin(angle)) - arrowLength * sin(angle + arrowAngle),
    );

    // Draw the arrowhead
    final path = Path()
      ..moveTo(end.dx - (25 * cos(angle)), end.dy - (25 * sin(angle)))
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..moveTo(end.dx - (25 * cos(angle)), end.dy - (25 * sin(angle)))
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainterSibling oldDelegate) {
    return start != oldDelegate.start ||
        end != oldDelegate.end ||
        color != oldDelegate.color;
  }
}

class ConnectionPainterToChild extends CustomPainter {
  final Offset start;
  final Offset end;
  final Offset curveStart;
  final Color color;
  final Offset center;

  ConnectionPainterToChild({
    required this.start,
    required this.end,
    required this.color,
    required this.curveStart,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 5.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the main line
    final pathStroke = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(start.dx, center.dy)
      ..arcToPoint(
        Offset(start.dx - radius, center.dy - radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(end.dx + radius, center.dy - radius)
      ..arcToPoint(
        Offset(end.dx, center.dy - radius * 2),
        radius: const Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(pathStroke, paint);
    const double arrowLength = 10.0;
    const double angle = pi / 6; // 30 degrees

    final Offset arrowPoint1 = Offset(
      end.dx + (25 * sin(angle)) + arrowLength * cos(angle - angle),
      end.dy + (25 * cos(angle)) + arrowLength * cos(angle - angle),
    );

    final Offset arrowPoint2 = Offset(
      end.dx + (25 * sin(angle)),
      end.dy + 25 + arrowLength,
    );

    // Draw the arrowhead
    final path = Path()
      // ..moveTo(end.dx, end.dy + (25 * cos(0)))
      // ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..moveTo(end.dx, end.dy + (25 * cos(0)))
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainterToChild oldDelegate) {
    return start != oldDelegate.start ||
        end != oldDelegate.end ||
        color != oldDelegate.color;
  }
}

class ConnectionPainterAunt extends CustomPainter {
  final Offset start;
  final Offset end;
  final Offset curveStart;
  final Color color;

  ConnectionPainterAunt({
    required this.start,
    required this.end,
    required this.color,
    required this.curveStart,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = curveStart.dx + 50;
    const radius = 5.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the main line
    final pathStroke = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(center, start.dy)
      ..arcToPoint(
        Offset(center - radius, start.dy + radius),
        radius: const Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(center - 2 * radius, end.dy - radius)
      ..arcToPoint(
        Offset(center - 2 * radius, end.dy),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(pathStroke, paint);
    const double arrowLength = 10.0;
    const double arrowAngle = pi / 6; // 30 degrees

    final Offset arrowPoint1 = Offset(
      end.dx - (25 * cos(0)) - arrowLength * cos(-arrowAngle),
      end.dy - (25 * sin(0)) - arrowLength * sin(-arrowAngle),
    );

    final Offset arrowPoint2 = Offset(
      end.dx - (25 * cos(0)) - arrowLength * cos(arrowAngle),
      end.dy - (25 * sin(0)) - arrowLength * sin(arrowAngle),
    );

    final pathAllow = Path()
      ..moveTo(end.dx - (25 * cos(0)), end.dy - (25 * sin(0)))
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..moveTo(end.dx - (25 * cos(0)), end.dy - (25 * sin(0)))
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(pathAllow, paint);

    //     final Offset arrowPoint1 = Offset(
    //   end.dx - (25 * cos(angle)) - arrowLength * cos(angle - arrowAngle),
    //   end.dy - (25 * sin(angle)) - arrowLength * sin(angle - arrowAngle),
    // );

    // final Offset arrowPoint2 = Offset(
    //   end.dx - (25 * cos(angle)) - arrowLength * cos(angle + arrowAngle),
    //   end.dy - (25 * sin(angle)) - arrowLength * sin(angle + arrowAngle),
    // );

    // // Draw the arrowhead
    // final path = Path()
    //   ..moveTo(end.dx - (25 * cos(angle)), end.dy - (25 * sin(angle)))
    //   ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
    //   ..moveTo(end.dx - (25 * cos(angle)), end.dy - (25 * sin(angle)))
    //   ..lineTo(arrowPoint2.dx, arrowPoint2.dy);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainterAunt oldDelegate) {
    return start != oldDelegate.start ||
        end != oldDelegate.end ||
        color != oldDelegate.color;
  }
}
