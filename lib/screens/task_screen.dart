import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';
import 'package:task_manager/forms/edit_task_form.dart';

import '../box/box.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Box<TaskManager> todoBox;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<TaskManager>('task');
  }

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
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      // gridDelegate:
                      //     const SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 100, //width
                      //   mainAxisExtent: 150, //height
                      //   crossAxisSpacing: 20,
                      //   childAspectRatio: 1,
                      //   mainAxisSpacing: 10,
                      // ),
                      padding: const EdgeInsets.all(8),
                      itemCount: taskManager.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskManager tasks = taskManager[index];
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(tasks.date!);
                                               String formattedTime =
                            DateFormat('hh:mm:ss').format(tasks.date!);
                        return InkWell(
                          onTap: () {
                            debugPrint('${taskManager[index]}');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditTaskForm(
                                  values: tasks,
                                  onClickedDone: (
                                    description,
                                    date,
                                  ) =>
                                      editDetails(tasks, description, date),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue[50],
                              ),
                              height: MediaQuery.of(context).size.height * 0.1,
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
