import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shortest_pathfinder/exception.dart';
import 'package:shortest_pathfinder/models/position.dart';
import 'package:shortest_pathfinder/models/result.dart';
import 'package:shortest_pathfinder/models/tasks.dart';

class PathFinderApiProvider {
  Future<List<Task>> loadTasks(url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        final res = json.decode(response.body);
        return (res['data'] as List).map((person) => Task.fromJson(person)).toList();

      case 429:
        throw TooManyRequests();
      case 500:
        throw InternalServerError();

      default:
        throw Exception('Unknown Error');
    }
  }

  Future<List<ServerResult>> postResults(url, Map<String, List<Position>> results) async {
    List<dynamic> res = [];
    results.forEach((key, value) {
      res.add(
          {
            'id': key,
            'result': {
              'steps': value.map((e) => {'x': e.x, 'y': e.y}).toList(),
              'path': 'path',
            }
          }
      );
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(res),
    );

    switch (response.statusCode) {
      case 200:
        final res = json.decode(response.body);
        return (res['data'] as List).map((person) => ServerResult.fromJson(person)).toList();

      case 429:
        throw TooManyRequests();
      case 500:
        throw InternalServerError();

      default:
        throw Exception('Unknown Error');
    }
  }
}
