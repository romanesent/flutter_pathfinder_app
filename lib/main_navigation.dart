import 'package:flutter/material.dart';
import 'package:shortest_pathfinder/presentation/home_screen.dart';
import 'package:shortest_pathfinder/presentation/process_screen.dart';
import 'package:shortest_pathfinder/presentation/result_detail_screen.dart';
import 'package:shortest_pathfinder/presentation/result_list_screen.dart';

abstract class MainNavigationRouteNames {
  static const homeScreen = 'home_screen';
  static const processScreen = 'process_screen';
  static const resultListScreen = 'result_list_screen';
  static const resultDetailScreen = 'result_detail_screen';
}

class MainNavigation {
  String initialRoute(bool isUrl) =>
      isUrl ? MainNavigationRouteNames.processScreen : MainNavigationRouteNames.homeScreen;

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case MainNavigationRouteNames.processScreen:
        return MaterialPageRoute(builder: (context) => const ProcessScreen());
      case MainNavigationRouteNames.resultListScreen:
        return MaterialPageRoute(builder: (context) => const ResultListScreen());
      case MainNavigationRouteNames.resultDetailScreen:
        return MaterialPageRoute(
            builder: (context) => ResultDetailScreen(arguments: settings.arguments));
      default:
        return null;
    }
  }
}
