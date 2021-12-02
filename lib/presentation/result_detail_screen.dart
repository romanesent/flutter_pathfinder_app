import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_cubit.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_state.dart';
import 'package:shortest_pathfinder/models/position.dart';
import 'package:shortest_pathfinder/models/result_detail_screen_arguments.dart';

class ResultDetailScreen extends StatefulWidget {
  Object? arguments;
  String? taskId;

  ResultDetailScreen({Key? key, required this.arguments}) : super(key: key) {
    taskId = (arguments as ResultDetailScreenArguments).id;
  }

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  final List<Position> gridList = [];
  final List<Position> gridClosedList = [];
  int? gridLength;
  PathFinderCubit? _pathFinderCubit;

  @override
  void initState() {
    _pathFinderCubit = BlocProvider.of<PathFinderCubit>(context);

    final List<String> field = _pathFinderCubit!.state.tasksMap[widget.taskId]!.field;
    gridLength = field.length;
    for (var i = 0; i < gridLength!; i++) {
      for (var j = 0; j < gridLength!; j++) {
        Position pos = Position(x: i, y: j);
        gridList.add(pos);
        if (field[i][j] == 'X') {
          gridClosedList.add(pos);
        }
      }
    }

    super.initState();
  }

  Color itemColor(Position position) {
    if (gridClosedList.contains(position)) {
      return Colors.black;
    } else if (_pathFinderCubit!.state.tasksMap[widget.taskId]!.start == position) {
      return Color(int.parse('0xFF64FFDA'));
    } else if (_pathFinderCubit!.state.tasksMap[widget.taskId]!.end == position) {
      return Color(int.parse('0xFF009688'));
    } else if (_pathFinderCubit!.state.results[widget.taskId]!.contains(position)) {
      return Color(int.parse('0xFF4CAF50'));
    } else {
      return Colors.white;
    }
  }

  Color itemTextColor(Position position) {
    if (gridClosedList.contains(position)) {
      return Colors.white;
    } else {
      return Colors.black87;
    }
  }

  Widget gridViewItem(Position position) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: itemColor(position),
      ),
      child: Text(
        '(${position.x}, ${position.y})',
        style: TextStyle(color: itemTextColor(position)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail result'),
      ),
      body: BlocBuilder<PathFinderCubit, PathFinderState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  color: Colors.black12,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: gridLength!,
                    padding: const EdgeInsets.all(3),
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    children: gridList.map((e) => gridViewItem(e)).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                state.results[widget.taskId]!.map((e) => '(${e.x},${e.y})').toList().join('->'),
              ),
              const SizedBox(height: 10),
              Text(
                'Result is ${state.serverResultMap[widget.taskId]!.correct ? 'correct' : 'not correct'}',
              ),
            ],
          );
        },
      ),
    );
  }
}
