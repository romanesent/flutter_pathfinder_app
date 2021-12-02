import 'package:equatable/equatable.dart';

class Position extends Equatable {
  const Position({
    required this.x,
    required this.y,
  });

  final int x;
  final int y;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    x: json["x"],
    y: json["y"],
  );

  @override
  List<Object?> get props => [x, y];
}
