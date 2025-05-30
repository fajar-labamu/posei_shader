import 'package:cash_fragment/flutter_shaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> with SingleTickerProviderStateMixin {
  int _counter = 0;
  late Ticker _ticker;

  Duration _elapsed = Duration.zero;

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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(assetKey: 'shaders/compare.frag', (BuildContext context, FragmentShader shader, _) {
      return Scaffold(
        body: Center(
          child: Align(
            alignment: Alignment.center,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                shader.setFloat(0, bounds.width * 5);
                shader.setFloat(1, bounds.height * 5);
                shader.setFloat(2, _elapsed.inMilliseconds.toDouble() / 1000);
                return shader;
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                '$_counter',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 256, color: Colors.white),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Text('+1'),
        ),
      );
    });
  }
}
