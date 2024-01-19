import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;

import '../constant/color_constant.dart';
import '../constant/layout.dart';

class Loading extends StatefulWidget {
  final PhoneSize size;

  const Loading({super.key, required this.size});

  @override
  State<StatefulWidget> createState() => _Loading();
}

class _Loading extends State<Loading> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 360,
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );
    animationController.repeat();
  }

    @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        color: ColorConst.white,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Stack(
            children: [
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: ClipPath(
                  clipper: CircleClipper(),
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: WavePainter(animationController: animationController, isRightDirection: true),
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: ClipPath(
                  clipper: CircleClipper(),
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: WavePainter(animationController: animationController, isRightDirection: false),
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: FlaskPainter(),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: ReflectionPainter(),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class ReflectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(-size.width / 2, -size.height / 2, size.width, size.height);

    var paint = Paint()
      ..colorFilter = ColorFilter.mode(ColorConst.white.withOpacity(0.1), BlendMode.softLight)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = ColorConst.paleYellow.withOpacity(0.1)
      ..strokeWidth = 20;

    final reflection = Path();
    reflection.addArc(rect, vector.radians(-10.0), vector.radians(35));
    reflection.addArc(rect, vector.radians(40.0), vector.radians(15));
    reflection.addArc(rect, vector.radians(70.0), vector.radians(5));

    canvas.drawPath(reflection, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FlaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(-size.width / 2, -size.height / 2, size.width, size.height);

    var paint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = ColorConst.paleYellow
      ..strokeWidth = 10;

    final flask = Path();
    flask.moveTo(math.sin(vector.radians(15.0)) * size.width / 2, -math.cos(vector.radians(15.0)) * size.height / 2 - 40);
    flask.arcTo(rect, vector.radians(-75.0), vector.radians(330), false);
    flask.relativeLineTo(0, -40);
    flask.close();

    final topRect = Rect.fromCenter(center: Offset(0, -size.height / 2 - 50), width: size.width / 3, height: 20);
    final topRRect = RRect.fromRectAndRadius(topRect, const Radius.circular(10));
    flask.addRRect(topRRect);
    canvas.drawPath(flask, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()..addOval(Rect.fromCenter(center: const Offset(0, 0), width: size.width, height: size.height));

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WavePainter extends CustomPainter {
  AnimationController animationController;
  final bool isRightDirection;
  WavePainter({required this.isRightDirection, required this.animationController});
  //static const int kWaveLength = 180;
  @override
  void paint(Canvas canvas, Size size) {
    double xOffset = size.width / 2;
    List<Offset> polygonOffsets = [];

    for (int i = -xOffset.toInt(); i <= xOffset; i++) {
      polygonOffsets.add(Offset(
          i.toDouble(),
          isRightDirection
              ? math.sin(vector.radians(i.toDouble() * 360 / 300) - vector.radians(animationController.value)) * 20 - 20
              : math.sin(vector.radians(i.toDouble() * 360 / 300) + vector.radians(animationController.value)) * 20 - 20));
    }

    final Gradient gradient = LinearGradient(
        begin: const Alignment(-1.0, -1.0), //top
        end: const Alignment(-1.0, 1.0), //center
        colors: const <Color>[
          ColorConst.mainColor,
          ColorConst.paleYellow,
        ],
        stops: [
          isRightDirection ? 0.1 : 0.4,
          isRightDirection ? 0.9 : 1
        ]);
    final wave = Path();
    wave.addPolygon(polygonOffsets, false);
    wave.lineTo(xOffset, size.height);
    wave.lineTo(-xOffset, size.height);
    wave.close();

    final rect = Rect.fromLTWH(0.0, isRightDirection ? -size.height / 5 - 25 : -size.height / 5 - 22, size.width, size.height / 2);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(wave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LoadingSize {
  final double top;
  final double left;

  LoadingSize({
    required this.top,
    required this.left,
  });
}

LoadingSize loadingSize(PhoneSize size) {
  return (size.loadingSize);
}

extension LoadingSizeExtension on PhoneSize {
  LoadingSize get loadingSize => switch (this) {
        PhoneSize.verticalMobile => LoadingSize(
            top: 0.2,
            left: 0.3,
          ),
        PhoneSize.horizonMobile => LoadingSize(
            top: 0.1,
            left: 0.3,
          ),
        PhoneSize.verticalTablet => LoadingSize(
            top: 0.05,
            left: 0.3,
          ),
        PhoneSize.horizonTablet => LoadingSize(
            top: 0.1,
            left: 0.3,
          ),
      };
}
