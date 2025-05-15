import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cash_fragment/flutter_shaders.dart';
import 'package:flutter/scheduler.dart';
import 'package:posei_shader/motion.dart';

class FreezeWidget extends StatefulWidget {
  const FreezeWidget({super.key});

  @override
  FreezeWidgetState createState() => FreezeWidgetState();
}

class FreezeWidgetState extends State<FreezeWidget> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _progress = 0.0;
  double _target = 5.0;
  bool _isFrozen = false;

  static const _lerpSpeed = 1.0; // Adjust to control lerp speed

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    const dt = 1 / 60.0; // Assuming 60fps for fixed step
    if ((_progress - _target).abs() < 0.001) return;

    setState(() {
      _progress = ui.lerpDouble(_progress, _target, dt * _lerpSpeed)!;
    });
  }

  void _toggleFreeze() {
    setState(() {
      _isFrozen = !_isFrozen;
      _target = _isFrozen ? 1.0 : 5.0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Brain Freeze')),
    body: Column(
      children: [
        ShaderBuilder(
          assetKey: 'shaders/freeze.frag',
          (BuildContext context, FragmentShader shader, _) => AnimatedSampler(
            (ui.Image image, Size size, Canvas canvas) {
              shader
                ..setFloat(0, size.width)
                ..setFloat(1, size.height)
                ..setFloat(2, _progress)
                ..setImageSampler(0, image);
              canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
            },
            child: Image.asset('assets/cat.jpg')
          ),
        ),
        ShaderBuilder(
          assetKey: 'shaders/freeze.frag',
          (BuildContext context, FragmentShader shader, _) => AnimatedSampler(
            (ui.Image image, Size size, Canvas canvas) {
              shader
                ..setFloat(0, size.width)
                ..setFloat(1, size.height)
                ..setFloat(2, _progress)
                ..setImageSampler(0, image);
              canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
            },
            child: CreditCardWidget(
              cardNumber: '1234 5678 9012 3456',
              cardHolder: 'JOHN DOE',
              expiryDate: '12/25',
              cvv: '123',
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _toggleFreeze, child: Text(_isFrozen ? 'Unfreeze' : 'Freeze')),
        const SizedBox(height: 20),
      ],
    ),
  );
}
