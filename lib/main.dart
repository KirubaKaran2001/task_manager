import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/forms/add_task_form.dart';
import 'package:task_manager/forms/edit_task_form.dart';
import 'package:task_manager/screens/task_screen.dart';

import 'database_modal/database_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskManagerAdapter());
  await Hive.openBox<TaskManager>('task');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskScreen(),
      onGenerateRoute: (RouteSettings settings) {
        debugPrint('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/taskScreen': (BuildContext context) => const TaskScreen(),
          '/addTask': (BuildContext context) => const AddTaskForm(),
          '/editTask': (BuildContext context) => const EditTaskForm(),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(
          builder: (ctx) => builder(ctx),
        );
      },
    );
  }
}
