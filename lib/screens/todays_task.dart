// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';
import 'package:task_manager/forms/edit_task_form.dart';
import '../box/box.dart';
import 'package:timezone/data/latest.dart' as tz;

class TodayTask extends StatefulWidget {
  const TodayTask({super.key});

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  late Box<TaskManager> todoBox;

  bool notificationsEnabled = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int id = 0;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    todoBox = Hive.box<TaskManager>('task');
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayTasks = todoBox.values
        .where((task) => task.date!.isAtSameMomentAs(today))
        .toList();
    print(todayTasks);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tasks',
          ),
        ),
        body: ValueListenableBuilder<Box<TaskManager>>(
          valueListenable: Boxes.getdetails().listenable(),
          builder: (context, box, _) {
            if (todayTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Tasks',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: todayTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskManager tasks = todayTasks[index];
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(tasks.date!);
                        String formattedTime =
                            DateFormat('hh:mm:ss').format(tasks.date!);
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditTaskForm(
                                  values: tasks,
                                  onClickedDone: (
                                    title,
                                    description,
                                    date,
                                  ) =>
                                      editDetails(
                                          tasks, title, description, date),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 15),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue[50],
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    children: [
                                      Text(
                                        tasks.description!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () {
                                      deleteDetails(tasks);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void editDetails(
    TaskManager taskManager,
    String title,
    String description,
    DateTime date,
  ) {
    taskManager.description = description;
    taskManager.date = date;
    taskManager.save();
  }

  void deleteDetails(TaskManager taskManager) {
    taskManager.delete();
  }
}
