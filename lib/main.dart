import 'dart:html';

import 'package:flutter/material.dart';

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
  List<Widget> containers = [
    Container(
      child: Stack(
        fit: StackFit.expand,
        children:
      )
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "그래프",
              ),
              Tab(
                text: "인접 행렬",
              ),
              Tab(
                text: "배열",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: containers,
        ),
      ),
    );
  }
}

Widget _btnNode(final Point point) => Positioned(
  left: point.x,
  top: point.y,
  child: FlatButton(

  )
)
