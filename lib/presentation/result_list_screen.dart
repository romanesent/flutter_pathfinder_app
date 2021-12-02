import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_cubit.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_state.dart';
import 'package:shortest_pathfinder/models/result_detail_screen_arguments.dart';

import '../main_navigation.dart';

class ResultListScreen extends StatefulWidget {
  const ResultListScreen({Key? key, Object? arguments}) : super(key: key);

  @override
  ResultListScreenState createState() => ResultListScreenState();
}

class ResultListScreenState extends State<ResultListScreen> {
  void onTapResultItem(id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.resultDetailScreen,
        arguments: ResultDetailScreenArguments(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MainNavigationRouteNames.homeScreen, (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Result list'),
        ),
        body: BlocBuilder<PathFinderCubit, PathFinderState>(
          builder: (context, state) {
            return ListView.separated(
              itemCount: state.results.entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    onTapResultItem(state.results.entries.toList()[index].key);
                  },
                  title: Text(
                    state.results.entries
                        .toList()[index]
                        .value
                        .map((e) => '(${e.x},${e.y})')
                        .toList()
                        .join('->'),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
