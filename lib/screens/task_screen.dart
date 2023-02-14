import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';

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
            List<TaskManager> taskManager = box.values.toList().cast<TaskManager>();
            if (taskManager.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('No Tasks'),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: taskManager.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskManager tasks = taskManager[index];
                        return Card(
                          child: Row(
                            children: [
                              Text(
                                tasks.description!,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
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

  void deleteDetails(TaskManager taskManager) {
    taskManager.delete();
  }
}
