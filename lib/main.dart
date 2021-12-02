import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_cubit.dart';
import 'package:shortest_pathfinder/main_navigation.dart';
import 'package:shortest_pathfinder/services/pathfinder_repository.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  final mainNavigation = MainNavigation();
  final PathFinderRepository _pathFinderRepository = PathFinderRepository();

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PathFinderCubit>(
              create: (context) => PathFinderCubit(repository: _pathFinderRepository)),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: MainNavigationRouteNames.homeScreen,
          onGenerateRoute: mainNavigation.onGenerateRoute,
        ));
  }
}
