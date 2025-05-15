import 'package:flutter/material.dart';
import 'package:posei_shader/compare.dart';
import 'package:posei_shader/counter.dart';
import 'package:posei_shader/freeze.dart';
import 'package:posei_shader/motion.dart';
import 'package:posei_shader/sea.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shader Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Shader Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  final List _pages = [
    () => CompareWidget(),
    () => CounterWidget(),
    () => FreezeWidget(),
    () => ScrollWidget(),
    () => SeaWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index](),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.numbers_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.severe_cold), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.waves_outlined), label: ''),
        ],
      ),
    );
  }
}
