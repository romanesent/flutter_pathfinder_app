import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_state.dart';
import 'package:shortest_pathfinder/models/grid_node.dart';
import 'package:shortest_pathfinder/models/position.dart';
import 'package:shortest_pathfinder/models/tasks.dart';
import 'package:shortest_pathfinder/services/pathfinder_repository.dart';

class PathFinderCubit extends Cubit<PathFinderState> {
  final PathFinderRepository repository;

  PathFinderCubit({required this.repository}) : super(PathFinderState());

  Future<void> loadSavedUrl() async {
    emit(state.copyWith(status: LoadingSavedURL()));

    try {
      final url = await repository.loadURL();
      emit(state.copyWith(status: LoadSavedURLSuccessful(), url: url));
    } catch (_) {
      emit(state.copyWith(status: LoadSavedURLError()));
    }
  }

  Future<void> saveURL(url) async {
    try {
      await repository.saveURL(url: url);
    } catch (_) {}
  }

  Future<void> loadTasks(url) async {
    emit(state.copyWith(
      status: LoadingTasks(),
      tasks: [],
      results: {},
      serverResult: [],
      currentCalcTask: 0,
    ));

    try {
      final tasks = await repository.loadTasks(url: url);

      emit(state.copyWith(status: LoadTasksSuccessful(), tasks: tasks, url: url));
      findPath();
    } catch (error) {
      emit(state.copyWith(status: LoadTasksError(error: error.toString())));
    }
  }

  Future<void> senResults() async {
    emit(state.copyWith(status: SendingPath()));

    try {
      final serverResult = await repository.postResult(url: state.url, results: state.results);

      emit(state.copyWith(status: SendPathSuccessful(), serverResult: serverResult));
    } catch (error) {
      emit(state.copyWith(status: SendPathError(error: error.toString())));
    }
  }

  Future<void> findPath() async {
    emit(state.copyWith(status: FindingPath()));

    Map<String, List<Position>> results = {};

    state.tasks.asMap().forEach((index, task) {
      results[task.id] = calcPath(task);
      if (state.tasks.isNotEmpty) {
        emit(state.copyWith(currentCalcTask: index + 1));
      }
    });

    if (state.tasks.isNotEmpty) {
      emit(state.copyWith(status: PathFound(), results: results));
    }
  }

  List<Position> calcPath(Task task) {
    int gridLength = task.field.length;
    List<List<int>> grid =
        List.generate(gridLength, (index) => List.generate(gridLength, (index) => 0));

    for (var i = 0; i < gridLength; i++) {
      for (var j = 0; j < gridLength; j++) {
        if (task.field[i][j] == 'X') {
          grid[i][j] = 1;
        }
      }
    }

    GridNode startNode = GridNode(
      parent: null,
      position: task.start,
      g: 0,
      h: 0,
      f: 0,
    );

    GridNode endNode = GridNode(
      parent: null,
      position: task.end,
      g: 0,
      h: 0,
      f: 0,
    );

    List<GridNode> openList = [];
    List<GridNode> closedList = [];

    openList.add(startNode);

    while (openList.isNotEmpty) {
      GridNode currentNode = openList[0];
      int currentIndex = 0;

      openList.asMap().forEach((index, node) {
        if (node.f! < currentNode.f!) {
          currentNode = node;
          currentIndex = index;
        }
      });

      openList.removeAt(currentIndex);
      closedList.add(currentNode);

      if (currentNode.position == endNode.position) {
        List<Position> path = [];
        GridNode? current = currentNode;

        while (current != null) {
          path.add(current.position);
          current = current.parent;
        }

        return path.reversed.toList();
      }

      List<Position> directions = [
        const Position(x: 0, y: -1),
        const Position(x: 0, y: 1),
        const Position(x: -1, y: 0),
        const Position(x: 1, y: 0),
        const Position(x: -1, y: -1),
        const Position(x: -1, y: 1),
        const Position(x: 1, y: -1),
        const Position(x: 1, y: 1),
      ];
      List<GridNode> children = [];

      for (var newPosition in directions) {
        Position nodePosition = Position(
          x: currentNode.position.x + newPosition.x,
          y: currentNode.position.y + newPosition.y,
        );

        if ((nodePosition.x > gridLength - 1) ||
            (nodePosition.x < 0) ||
            (nodePosition.y > gridLength - 1) ||
            (nodePosition.y < 0)) {
          continue;
        }

        if (grid[nodePosition.x][nodePosition.y] != 0) {
          continue;
        }

        children.add(GridNode(parent: currentNode, position: nodePosition));
      }

      for (var child in children) {
        for (var closedNode in closedList) {
          if (child.position == closedNode.position) {
            continue;
          }
        }

        child.g = currentNode.g! + 1;
        child.h = (pow((child.position.x - endNode.position.x), 2) +
            pow((child.position.y - endNode.position.y), 2)) as int;
        child.f = child.g! + child.h!;

        for (var openNode in openList) {
          if ((child.position == openNode.position) && (child.g! > openNode.g!)) {
            continue;
          }
        }

        openList.add(child);
      }
    }

    return [];
  }
}
