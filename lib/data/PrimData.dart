import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';

class Geometric {
  List<Point> ps;
  List<Line> ls;
  int _listMaxSize;

  Geometric(int size){
    ps = new List();
    ls = new List();
    _listMaxSize = size;
  }

  void init(){
    ps.clear();
  }

  void addPoint(Point p){
    if(ps.length < _listMaxSize){
      ps.add(p);
    }
  }

  void addLine(Line l){
    ls.add(l);
  }
}

class Prim {
  List<List<int>> matrix;
  List<Line> edge_list;
  final int INF = 9999999;

  void setMatrix(List<List<int>> matrix){
    this.matrix = matrix;
  }

  void PrimAlgorithm(List<Line> ls){
    int node_num = matrix[0].length;
    PriorityQueue<Line> q = new PriorityQueue<Line>(comparison);
    List<bool> visited = new List<bool>.filled(node_num, false);

    ls.clear();
    // 시작 노드는 무조건 0노드
    Line line = new Line(0, 0, 0);
    q.add(line);
    while(!q.isEmpty){
      Line l = q.first;
      int from = q.first.getIdxP1;
      int before = q.first.getIdxP2;
      int weight = q.first.getWeight;
      q.removeFirst();

      if(visited[from]) continue;
      visited[from] = true;
      if(weight != 0)
        ls.add(l);

      for(int to = 0; to < node_num; to++){
        if(matrix[from][to] != 0){
          if(!visited[to]){
            Line tmp_line = new Line(to, from, matrix[from][to]);
            q.add(tmp_line);
          }
        }
      }
    }
    edge_list = ls;

    print("알고리즘 후 : " + ls.length.toString());
    for(int i=0;i<ls.length; i++){
      print("알고리즘 후2 : ( " + ls[i].getIdxP1.toString() + ", " + ls[i].getIdxP2.toString() + ", " +
      ls[i].getWeight.toString() + ")");
    }
  }

  int comparison(Line l1, Line l2){
    int w1 = l1.getWeight;
    int w2 = l2.getWeight;
    if(w1 > w2) return 1;
    else if(w1 == w2) return 0;
    else return -1;
  }
}

class Line {
  int _idxP1;
  int _idxP2;
  int _weight;

  Line(int p1, int p2, int weight){
    this._idxP1 = p1;
    this._idxP2 = p2;
    this._weight = weight;
  }

  int get getIdxP1 => this._idxP1;
  int get getIdxP2 => this._idxP2;
  int get getWeight => this._weight;
}