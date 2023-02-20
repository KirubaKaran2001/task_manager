// ignore_for_file: depend_on_referenced_packages, unused_local_variable, void_checks, sized_box_for_whitespace
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';
import 'package:task_manager/forms/edit_task_form.dart';
import '../box/box.dart';
import 'package:timezone/data/latest.dart' as tz;

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Box<TaskManager> todoBox;

  bool notificationsEnabled = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int id = 0;
  bool showLayout = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    todoBox = Hive.box<TaskManager>('task');
  }

  List<Color> colorsList = [
    const Color(0xffACC8E5),
    Colors.orange,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: const [
              Icon(
                Icons.add,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Add a Task'),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/addTask');
          },
        ),
        appBar: AppBar(
          title: const Text(
            'Task Manager',
          ),
        ),
        body: ValueListenableBuilder<Box<TaskManager>>(
          valueListenable: Boxes.getdetails().listenable(),
          builder: (context, box, _) {
            List<TaskManager> taskManager =
                box.values.toList().cast<TaskManager>();
            if (taskManager.isEmpty) {
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
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250, //width
                        mainAxisExtent: 180, //height
                        crossAxisSpacing: 20,
                        childAspectRatio: 1,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.all(8),
                      itemCount: taskManager.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskManager tasks = taskManager[index];
                        final completedTask = todoBox.getAt(index);
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(tasks.date!);
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
                          onLongPress: () {
                            setState(() {
                              showLayout = true;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          tasks.title!,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                        (showLayout == true)
                                            ? Checkbox(
                                                value: tasks.completed,
                                                onChanged: (value) {
                                                  setState(() {
                                                    tasks.completed = value;
                                                    todoBox.putAt(
                                                      index,
                                                      completedTask!,
                                                    );
                                                    showLayout = false;
                                                  });
                                                },
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              (showLayout == true)
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                        onPressed: () {
                                          deleteDetails(tasks);
                                          showLayout = false;
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
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
    taskManager.title = title;
    taskManager.description = description;
    taskManager.date = date;
    taskManager.save();
  }

  void deleteDetails(TaskManager taskManager) {
    taskManager.delete();
  }

  Color getRandomColors(List<Color> colorsList, int index) {
    final random = Random();
    final colors = random.nextInt(colorsList.length);
    return colorsList[colors];
  }
}
