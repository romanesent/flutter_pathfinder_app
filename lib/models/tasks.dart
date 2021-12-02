import 'package:shortest_pathfinder/models/position.dart';

class Task {
  Task({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  String id;
  List<String> field;
  Position start;
  Position end;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    field: List<String>.from(json["field"].map((x) => x)),
    start: Position.fromJson(json["start"]),
    end: Position.fromJson(json["end"]),
  );
}
