// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/forms/add_task_form.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/task_screen.dart';
import 'package:task_manager/screens/completed_task.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/screens/today_task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'database_modal/database_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskManagerAdapter());
  await Hive.openBox<TaskManager>('task');
  NotificationService().initNotification();
  tz.initializeTimeZones();
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
        scaffoldBackgroundColor: const Color(0xff101035),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: Color(0xffebebeb),
            fontSize: 20,
          ),
          displaySmall: TextStyle(
            color: Color(0xffebebeb),
            fontSize: 15,
          ),
          displayLarge: TextStyle(
            color: Color(0xffebebeb),
            fontSize: 15,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xff68d3ff),
          extendedTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.white,
            ),
            backgroundColor: const Color(0xff080C14),
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff080C14),
          titleTextStyle: TextStyle(
            color: Color(0xffebebeb),
          ),
          iconTheme: IconThemeData(
            color: Color(0xffECE7FF),
          ),
          actionsIconTheme: IconThemeData(
            color: Color(0xffECE7FF),
          ),
        ),
        dividerColor: Colors.white,
        cardColor: const Color(0xff121B2F).withOpacity(0.8),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(
              secondary: Colors.blue,
            )
            .copyWith(error: Colors.blueGrey[50]),
      ),
      home: const HomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        debugPrint('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/homeScreen': (BuildContext context) => const HomeScreen(),
          '/taskScreen': (BuildContext context) => const TaskScreen(),
          '/addTask': (BuildContext context) => const AddTaskForm(),
          '/completedTask': (BuildContext context) => const CompletedTask(),
          '/todayTask': (BuildContext context) => const TodayTaskScreen(),
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
