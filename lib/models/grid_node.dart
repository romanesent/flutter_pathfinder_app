import 'package:shortest_pathfinder/models/position.dart';

class GridNode {
  GridNode? parent;
  Position position;
  int? g;
  int? h;
  int? f;

  GridNode({
    required this.parent,
    required this.position,
    this.g,
    this.h,
    this.f,
  });
}
