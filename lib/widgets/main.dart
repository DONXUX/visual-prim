import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visual_prim_algorithm/Graph.dart';
import 'package:visual_prim_algorithm/Matrix.dart';
import 'package:visual_prim_algorithm/Array.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '프림 알고리즘 시각화',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: '프림 알고리즘 시각화'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    GraphPageState(),
    MatrixPageState(),
    ArrayPageState()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: Text('그래프'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: Text('인접행렬'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: Text('배열'),
          ),
        ],
      ),
      body: _pageOptions[_selectedPage],
    );
  }
}