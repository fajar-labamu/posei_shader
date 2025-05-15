import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cash_fragment/flutter_shaders.dart';

class ScrollWidget extends StatefulWidget {
  const ScrollWidget({super.key});

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0.0;
  double _scrollVelocity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateVelocity);
  }

  void _updateVelocity() {
    final currentOffset = _scrollController.offset;
    final delta = currentOffset - _lastOffset;
    _lastOffset = currentOffset;
    setState(() {
      _scrollVelocity = delta; // horizontal is 0.0, vertical is delta
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motion Blur List (WEB NOT SUPPORTED)')),
      body: ShaderBuilder(
        assetKey: 'shaders/motion.frag',
        (context, shader, _) {
          return AnimatedSampler(
            (ui.Image image, Size size, Canvas canvas) {
              shader
                ..setFloat(0, size.width)     // u_size.x
                ..setFloat(1, size.height)    // u_size.y
                ..setFloat(2, 0.0)            // u_velocity.x (horizontal scroll, unused)
                ..setFloat(3, _scrollVelocity) // u_velocity.y
                ..setImageSampler(0, image);
              canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
            },
            child: _buildList(),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 30,
      itemBuilder: (context, index) => 

            CreditCardWidget(
              cardNumber: '1234 5678 9012 3456',
              cardHolder: 'JOHN DOE',
              expiryDate: '12/25',
              cvv: '123',
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;

  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Card(
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CREDIT CARD', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const Spacer(),
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CARDHOLDER\n$cardHolder', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('EXPIRES\n$expiryDate', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
