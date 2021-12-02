import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_cubit.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_state.dart';

import '../main_navigation.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({Key? key}) : super(key: key);

  @override
  ProcessScreenState createState() => ProcessScreenState();
}

class ProcessScreenState extends State<ProcessScreen> {
  void onPressBtnSendResult() {
    BlocProvider.of<PathFinderCubit>(context).senResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: BlocConsumer<PathFinderCubit, PathFinderState>(
        listener: (context, state) {
          switch (state.status.runtimeType) {
            case SendPathError:
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(state.status.error.toString()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
              break;

            case SendPathSuccessful:
              Navigator.of(context).pushNamed(MainNavigationRouteNames.resultListScreen);
              break;
          }
        },
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.status is FindingPath
                            ? 'The process of calculating the paths is in progress'
                            : 'All calculations completed. You can send your results to server',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CircularPercentIndicator(
                        radius: 200,
                        lineWidth: 3,
                        percent: state.calcPercent,
                        center: Text(
                          state.calcPercentText,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        progressColor: Colors.blue,
                      )
                    ],
                  ),
                ),
                state.status is PathFound ||
                        state.status is SendingPath ||
                        state.status is SendPathError
                    ? Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: state.status is SendingPath
                                ? const Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: onPressBtnSendResult,
                                    child: const Text(
                                      'Send results',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}
