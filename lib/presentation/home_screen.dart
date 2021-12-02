import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_cubit.dart';
import 'package:shortest_pathfinder/cubits/pathfinder_state.dart';
import 'package:shortest_pathfinder/main_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlFieldController = TextEditingController();

  PathFinderCubit? _pathFinderCubit;

  @override
  void initState() {
    _pathFinderCubit = BlocProvider.of<PathFinderCubit>(context);

    _pathFinderCubit!.loadSavedUrl();

    super.initState();
  }

  void onPressBtnStart() {
    if (_formKey.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
      _pathFinderCubit!.saveURL(_urlFieldController.text);
      _pathFinderCubit!.loadTasks(_urlFieldController.text);
    }
  }

  bool isValidUrl(url) {
    RegExp exp = RegExp(
        r"(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?");
    return exp.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: BlocConsumer<PathFinderCubit, PathFinderState>(
        listener: (context, state) {
          switch (state.status.runtimeType) {
            case LoadTasksError:
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

            case LoadTasksSuccessful:
              Navigator.of(context).pushNamed(MainNavigationRouteNames.processScreen);
              break;

            case LoadSavedURLSuccessful:
              _urlFieldController.text = state.url!;
              break;
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Set valid API base URL in order to continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: AbsorbPointer(
                        absorbing: state.status is LoadingSavedURL,
                        child: TextFormField(
                          controller: _urlFieldController,
                          validator: (value) => isValidUrl(value) ? null : 'Please enter valid URL',
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.link,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: state.status is LoadingTasks
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: onPressBtnStart,
                              child: const Text(
                                'Start',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
