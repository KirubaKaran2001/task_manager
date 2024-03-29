// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';
import '../box/box.dart';
import 'package:timezone/data/latest.dart' as tz;

class CompletedTask extends StatefulWidget {
  const CompletedTask({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  late Box<TaskManager> todoBox;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    todoBox = Hive.box<TaskManager>('task');
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = todoBox.values
        .where(
          (task) => task.completed!,
        )
        .toList();
    print(completedTasks);

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
            if (completedTasks.isEmpty) {
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
                      itemCount: completedTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskManager tasks = completedTasks[index];
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(tasks.date!);
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
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
