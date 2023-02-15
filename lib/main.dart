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
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff121b2f),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: Color(0xffECE7FF),
            fontSize: 20,
          ),
          displaySmall: TextStyle(
            color: Color(0xffECE7FF),
            fontSize: 15,
          ),
          displayLarge: TextStyle(
            color: Color(0xffECE7FF),
            fontSize: 15,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xff080C14),
          extendedTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff080C14),
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff080C14),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Color(0xffECE7FF),
          ),
          actionsIconTheme: IconThemeData(
            color: Color(0xffECE7FF),
          ),
          
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.blue,
        ),
        dividerColor: Colors.white,
        errorColor: Colors.black,
        cardColor: const Color(0xff121B2F).withOpacity(0.8),
      ),
      home: const TaskScreen(),
      onGenerateRoute: (RouteSettings settings) {
        debugPrint('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/taskScreen': (BuildContext context) => const TaskScreen(),
          '/addTask': (BuildContext context) => const AddTaskForm(),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(
          builder: (ctx) => builder(ctx),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
