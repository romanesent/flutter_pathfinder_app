import 'package:shortest_pathfinder/models/position.dart';
import 'package:shortest_pathfinder/models/result.dart';
import 'package:shortest_pathfinder/models/tasks.dart';

abstract class PathFinderStatus {
  const PathFinderStatus();

  String? get error => null;
}

class Init extends PathFinderStatus {
  const Init();
}

class LoadingSavedURL extends PathFinderStatus {}

class LoadSavedURLSuccessful extends PathFinderStatus {}

class LoadSavedURLError extends PathFinderStatus {}

class LoadingTasks extends PathFinderStatus {}

class LoadTasksSuccessful extends PathFinderStatus {}

class LoadTasksError extends PathFinderStatus {
  @override
  final String error;

  LoadTasksError({required this.error});
}

class FindingPath extends PathFinderStatus {}

class PathFound extends PathFinderStatus {}

class SendingPath extends PathFinderStatus {}

class SendPathSuccessful extends PathFinderStatus {}

class SendPathError extends PathFinderStatus {
  @override
  final String error;

  SendPathError({required this.error});
}

class PathFinderState {
  final PathFinderStatus status;
  final List<Task> tasks;
  String? url;
  final int currentCalcTask;
  final Map<String, List<Position>> results;
  final List<ServerResult> serverResult;

  double get calcPercent => currentCalcTask / tasks.length;

  String get calcPercentText => (calcPercent * 100).toStringAsFixed(0) + '%';

  Map<String, Task> get tasksMap => {for (var item in tasks) item.id: item};

  Map<String, ServerResult> get serverResultMap => {for (var item in serverResult) item.id: item};

  PathFinderState({
    this.status = const Init(),
    this.tasks = const [],
    this.url,
    this.currentCalcTask = 0,
    this.results = const {},
    this.serverResult = const [],
  });

  PathFinderState copyWith({
    PathFinderStatus? status,
    List<Task>? tasks,
    String? url,
    int? currentCalcTask,
    Map<String, List<Position>>? results,
    List<ServerResult>? serverResult,
  }) {
    return PathFinderState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      url: url ?? this.url,
      currentCalcTask: currentCalcTask ?? this.currentCalcTask,
      results: results ?? this.results,
      serverResult: serverResult ?? this.serverResult,
    );
  }
}
