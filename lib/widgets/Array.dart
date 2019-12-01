import 'package:flutter/material.dart';
import 'package:visual_prim_algorithm/data/PrimData.dart';

class ArrayPageState extends StatelessWidget {
  ArrayPageState({Key key, this.prim}) : super(key: key);

  final Prim prim;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: prim.tree == null ? null : _printTree()
    );
  }

  Widget _printTree() {
    int gridStateLength = prim.tree[0].length;
    return Column(
      children: <Widget>[
        AspectRatio(
            aspectRatio: 1.0,
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),

                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridStateLength,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: 2 * gridStateLength,
                )
            )
        )
      ],
    );
  }

  Widget _buildGridItems(BuildContext context, int index){
    int gridStateLength = prim.tree[0].length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
        onTap: () => null,
        child: GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)
                ),
                child: Center(
                    child: Text(prim.tree[x][y].toString())
                )
            )
        )
    );
  }
}