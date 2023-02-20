// ignore_for_file: depend_on_referenced_packages, must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/box/box.dart';
import '../database_modal/database_modal.dart';
import 'package:timezone/data/latest.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController tasksController = TextEditingController();

  late Box<TaskManager> todoBox;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    todoBox = Hive.box<TaskManager>('task');
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d').format(now);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task Manager',
          ),
        ),
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
        body: ValueListenableBuilder<Box<TaskManager>>(
          valueListenable: Boxes.getdetails().listenable(),
          builder: (context, box, _) {
            List<TaskManager> taskManager =
                box.values.toList().cast<TaskManager>();
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final todayTasks = todoBox.values
                .where((task) => task.date!.isAtSameMomentAs(today))
                .toList();

            final CompletedTasks = todoBox.values
                .where(
                  (task) => task.completed!,
                )
                .toList();
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: tasksController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Search Task...',
                      hintStyle: Theme.of(context).textTheme.displaySmall,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeCardLayout(
                        formattedDate: formattedDate,
                        taskManager: taskManager,
                        taskList: todayTasks.length.toString(),
                        details: 'Today',
                        widgets: Text(formattedDate),
                        color: Colors.blue,
                        callbackAction: () {
                          Navigator.pushNamed(context, '/todayTask');
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      HomeCardLayout(
                        formattedDate: '',
                        taskManager: taskManager,
                        taskList: taskManager.length.toString(),
                        details: 'All',
                        widgets: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        color: Colors.red,
                        callbackAction: () {
                          Navigator.pushNamed(context, '/taskScreen');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  HomeCardLayout(
                    formattedDate: '',
                    taskManager: taskManager,
                    taskList: CompletedTasks.length.toString(),
                    details: 'Completed',
                    widgets: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    color: Colors.orange[300],
                    callbackAction: () {
                      Navigator.pushNamed(context, '/completedTask');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeCardLayout extends StatelessWidget {
  String? taskList;
  Widget? widgets;
  String? details;
  Color? color;
  Function()? callbackAction;

  HomeCardLayout({
    Key? key,
    required this.formattedDate,
    required this.taskManager,
    required this.taskList,
    required this.widgets,
    required this.details,
    required this.color,
    required this.callbackAction,
    // required this.callback,
  }) : super(key: key);

  final String formattedDate;
  final List<TaskManager> taskManager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callbackAction!();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          color: const Color(0xff232544),
          border: Border.all(color: Colors.white38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: widgets,
                  ),
                  Text(
                    taskList!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                details!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
