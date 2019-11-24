import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visual_prim_algorithm/data/PrimData.dart';
import 'package:visual_prim_algorithm/widgets/Matrix.dart';

import 'main.dart';

class GraphPage extends StatefulWidget {
  GraphPage({Key key, this.title, this.prim}) : super(key: key);

  final String title;
  final Prim prim;

  @override
  _GraphPageState createState() => _GraphPageState(prim);
}

class _GraphPageState extends State<GraphPage> {
  static Offset _p1;
  static Offset _p2;
  static int _idxP1;
  static int _idxP2;
  Prim prim;
  int nodePrintCnt = 0;

  static Geometric geometric = new Geometric(100);
  bool isTapDownDisabled = false;
  bool isPanStartDisabled = false;
  bool isPanUpdateDisabled = false;
  bool isPanEndDisabled = false;
  bool isFirstNodeTouch = false;
  bool isTwoNodeSelect = false;
  bool isPrimBtnDisabled = true;
  bool mst = false;

  _GraphPageState(Prim prim){
    this.prim = prim;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.undo,
        ),
        onPressed: onClickBtnInit,
      ),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) => isTapDownDisabled ? null : onTapDown(context, details),
        onPanStart: (DragStartDetails details) => isPanStartDisabled ? null : onPanStart(context, details),
        onPanUpdate: (DragUpdateDetails details) => isPanUpdateDisabled ? null : onPanUpdate(context, details),
        onPanEnd: (DragEndDetails details) => isPanEndDisabled ? null : onPanEnd(context, details),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
              painter: new PathPainter(geometric, _p1, _p2, mst),
            ),
            Container(
              padding: const EdgeInsets.all(0.0),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Stack(
                    fit: StackFit.expand,
                    children: geometric.ps
                        .map(_Node)
                        .toList(),
                  ),

                  Stack(
                    fit: StackFit.expand,
                    children: geometric.ls
                        .map(_Weight)
                        .toList(),
                  ),

                ],
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(16.0),
              child: RaisedButton(
                  key: null,
                  onPressed: isPrimBtnDisabled ? null : onClickBtnPrim,
                  color: Colors.indigo,
                  padding: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                      "최소 신장트리",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      )
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClickBtnPrim(){
    int node_num = geometric.ps.length;

    // 인접행렬 초기화
    List<List<int>> tmp_matrix = new List<List<int>>.generate(
        node_num, (i) => List<int>.generate(node_num, (j) => 0));
    prim.setMatrix(tmp_matrix);

    // 인접행렬 생성
    for(Line l in geometric.ls){
      print("(" + l.getIdxP1.toString() + ", " + l.getIdxP2.toString() + ")");
      prim.matrix[l.getIdxP1][l.getIdxP2] = l.getWeight;
      prim.matrix[l.getIdxP2][l.getIdxP1] = l.getWeight;
    }

    // DEBUG
    print("행렬 : " + prim.matrix.toString());

    // 프림 알고리즘
    setState(() {
      prim.PrimAlgorithm(geometric.ls);
    });

    mst = true;
    isTapDownDisabled = true;
    isPanStartDisabled = true;
    isPanUpdateDisabled = true;
    isPanEndDisabled = true;
    isFirstNodeTouch = true;
    isTwoNodeSelect = true;
    isPrimBtnDisabled = true;
  }

  void onClickBtnInit(){
    setState(() {
      geometric.ps.clear();
      geometric.ls.clear();
      isTapDownDisabled = false;
      isPanStartDisabled = false;
      isPanUpdateDisabled = false;
      isPanEndDisabled = false;
      isFirstNodeTouch = false;
      isTwoNodeSelect = false;
      mst = false;
      isPrimBtnDisabled = true;
      geometric = new Geometric(100);
    });
  }

  /// 화면 터치 이벤트입니다.
  /// 터치된 좌표를 입력받고 해당 좌표에 점을 띄웁니다.
  void onTapDown(BuildContext context, TapDownDetails details) {
    double posx = 0.0;
    double posy = 0.0;
    print("${details.globalPosition}");
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx;
    posy = localOffset.dy;
    print("좌표 : " + posx.toString() + "," + posy.toString());

    bool isExistPoint = false;
      for(Point p in geometric.ps){
        // 점이 이미 존재한다면 누른 터치 좌표값을 해당 점의 좌표로 바꿉니다.
        if(posx>=p.x - 24.0 && posx <=p.x + 24.0 && posy>=p.y - 24.0 && posy <= p.y + 24.0) {
          isExistPoint = true;
          break;
        }
    }

    // 누른 좌표를 가지고있는 점이 존재하지 않다면,
    // 점 정보 리스트 저장 후 화면을 갱신합니다.
    if(!isExistPoint) {
      setState(() {
        Point p = new Point(posx, posy);
        geometric.addPoint(p);
        isPrimBtnDisabled = false;
        nodePrintCnt = 0;
      });
    }
  }

  // 드래그 시작 점
  void onPanStart(BuildContext context, DragStartDetails details) {
    double posx = 0.0;
    double posy = 0.0;
    print("${details.globalPosition}");
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx;
    posy = localOffset.dy;

    int cnt = 0;
    for (Point p in geometric.ps) {
      // 점이 이미 존재한다면 누른 터치 좌표값을 해당 점의 좌표로 바꿉니다.
      if (posx >= p.x - 24.0 && posx <= p.x + 24.0 && posy >= p.y - 24.0 &&
          posy <= p.y + 24.0) {
        posx = p.x;
        posy = p.y;
        isFirstNodeTouch = true;
        _p1 = new Offset(p.x, p.y);
        _idxP1 = cnt;
        break;
      }
      cnt++;
    }
  }

  // 드래그 중간 점
  void onPanUpdate(BuildContext context, DragUpdateDetails details){
    if(isFirstNodeTouch) {
      double posx = 0.0;
      double posy = 0.0;
      print("${details.globalPosition}");
      final RenderBox box = context.findRenderObject();
      final Offset localOffset = box.globalToLocal(details.globalPosition);
      posx = localOffset.dx;
      posy = localOffset.dy;

      setState(() {
        _p2 = new Offset(posx, posy);
      });
    }
  }

  // 드래그 끝 점
  void onPanEnd(BuildContext context, DragEndDetails details) {
    if(isFirstNodeTouch) {
      int cnt = 0;
      for (Point p in geometric.ps) {
        // 점이 이미 존재한다면 누른 터치 좌표값을 해당 점의 좌표로 바꿉니다.
        if (_p2.dx >= p.x - 12.0 && _p2.dx <= p.x + 12.0 && _p2.dy >= p.y - 12.0 &&
            _p2.dy <= p.y + 12.0) {
          isTwoNodeSelect = true;
          _p2 = new Offset(p.x, p.y);
          _idxP2 = cnt;
          break;
        }
        cnt++;
      }
    }

    // 존재하는 두 개의 노드를 연결 할 경우
    // 연결 후 선 정보를 저장합니다.
    if(isTwoNodeSelect) {
      Point pp1 = new Point(_p1.dx, _p1.dy);
      Point pp2 = new Point(_p2.dx, _p2.dy);
      Future inputLine() async {
        int weight = int.parse(await _asyncWeightInputDialog(context));
        print("가중치 : " + weight.toString());
        Line l = new Line(_idxP1, _idxP2, weight);
        geometric.ls.add(l);
        // DEBUG
        for(int i =0;i<geometric.ls.length;i++){
          print("라인 " + i.toString() + " : (" + geometric.ls[i].getIdxP1.toString() +
              ", " +geometric.ls[i].getIdxP2.toString() + ", " + geometric.ls[i].getWeight.toString() + ")");
        }
        setState(() {});
      }
      inputLine();
    }
    else{
      _p1 = null;
      _p2 = null;
      setState(() {});
    }
    print("진행");

    isFirstNodeTouch = false;
    isTwoNodeSelect = false;
    _p1 = null;
    _p2 = null;
  }

  // 노드 출력 위젯
  Widget _Node(final Point point)  => Positioned(
      left: point.x - 12,
      top: point.y - 12,
      child: Icon(
                Icons.lens,
                size: 24.0,
              ),
  );

  // 가중치 텍스트 출력 위젯
  Widget _Weight(final Line line)  => Positioned(
      left: ((geometric.ps[line.getIdxP1].x + geometric.ps[line.getIdxP2].x) / 2) - 16,
      top: ((geometric.ps[line.getIdxP1].y + geometric.ps[line.getIdxP2].y) / 2) - 16,
      child: Text(
        line.getWeight.toString(),
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      )
  );
}

// 선 그리기를 담당하는 클래스입니다.
class PathPainter extends CustomPainter {
  Geometric _geometric;
  Offset _p1, _p2;
  bool mst;

  PathPainter(Geometric g, Offset p1, Offset p2, bool mst) {
    _geometric = g;
    this._p1 = p1;
    this._p2 = p2;
    this.mst = mst;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    if(!mst) {
      if (_p1 != null && _p2 != null)
        canvas.drawLine(_p1, _p2, paint);

      for (int i = 0; i < _geometric.ls.length; i++) {
        Offset p1 = Offset(_geometric.ps[_geometric.ls[i].getIdxP1].x,
            _geometric.ps[_geometric.ls[i].getIdxP1].y);
        Offset p2 = Offset(_geometric.ps[_geometric.ls[i].getIdxP2].x,
            _geometric.ps[_geometric.ls[i].getIdxP2].y);
        canvas.drawLine(p1, p2, paint);
      }
    }
    else {
      List<Line> l = _geometric.ls;
      for(int i = 0; i < l.length; i++){
        Offset mp1, mp2;
        mp1 = Offset(_geometric.ps[l[i].getIdxP1].x, _geometric.ps[l[i].getIdxP1].y);
        mp2 = Offset(_geometric.ps[l[i].getIdxP2].x, _geometric.ps[l[i].getIdxP2].y);
        canvas.drawLine(mp1, mp2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Future<String> _asyncWeightInputDialog(BuildContext context) async {
  String weight = '';
  return showDialog<String> (
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('가중치 입력'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '가중치',
                  hintText: '가중치',
                ),
                onChanged: (value) {
                  weight = value;
                },
              )
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: (){
              Navigator.of(context).pop(weight);
              print("가중치2 : " + weight);
            },
          )
        ],
      );
    }
  );
}
