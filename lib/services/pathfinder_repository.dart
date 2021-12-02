import 'package:shortest_pathfinder/models/result.dart';
import 'package:shortest_pathfinder/models/tasks.dart';
import 'package:shortest_pathfinder/services/pathfinder_api_provider.dart';
import 'package:shortest_pathfinder/services/pathfinder_local_provider.dart';

class PathFinderRepository {
  final PathFinderApiProvider _apiProvider = PathFinderApiProvider();
  final PathFinderLocalProvider _localProvider = PathFinderLocalProvider();

  Future<List<Task>> loadTasks({required url}) => _apiProvider.loadTasks(url);

  Future<List<ServerResult>> postResult({required url, required results}) => _apiProvider.postResults(url, results);

  Future<String> loadURL() => _localProvider.loadURL();

  Future<void> saveURL({required url}) => _localProvider.saveURL(url);
}
