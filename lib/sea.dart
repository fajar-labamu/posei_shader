
import 'package:cash_fragment/flutter_shaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SeaWidget extends StatefulWidget {
  const SeaWidget({super.key});

  @override
  SeaWidgetState createState() => SeaWidgetState();
}

class SeaWidgetState extends State<SeaWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;

  // ← we store the last tap/drag position here:
  Offset _pointer = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShaderBuilder(
    assetKey: 'shaders/sea.frag',
    (BuildContext context, FragmentShader shader, _) => Scaffold(
      body: GestureDetector(
        // update _pointer on tap or drag:
        onPanDown: (e) => setState(() => _pointer = e.localPosition),
        onPanUpdate: (e) => setState(() => _pointer = e.localPosition),
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ShaderCustomPainter(shader, _elapsed, _pointer),
        ),
      ),
    ),
  );
}

class ShaderCustomPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;
  final Offset pointer; // new

  ShaderCustomPainter(this.shader, this.currentTime, this.pointer);

  @override
  void paint(Canvas canvas, Size size) {
    // 0: width, 1: height, 2: time
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, currentTime.inMilliseconds.toDouble() / 1000.0)
      // 3: mouse.x, 4: mouse.y
      ..setFloat(3, pointer.dx)
      ..setFloat(4, pointer.dy);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant ShaderCustomPainter old) => true;
}

