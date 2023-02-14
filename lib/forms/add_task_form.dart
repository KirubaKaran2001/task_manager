// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/box/box.dart';
import 'package:task_manager/database_modal/database_modal.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ADD A TASK',
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      //  fit: FlexFit.loose,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            0.50, //when it reach the max it will use scroll
                        maxWidth: double.infinity,
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Type...',
                          border: InputBorder.none,
                        ),
                        onSaved: (val) {
                          TaskManager().description = val;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Date',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Date Of Birth',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                          });
                        } else {
                          debugPrint("Date is not selected");
                        }
                      },
                      validator: (val) {
                        if (dateController.text == '') {
                          return 'Please enter the date';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Time',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Select time',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final initialTime = _selectedTime ?? TimeOfDay.now();
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                          final formattedTime = DateFormat('HH:mm').format(
                            DateTime(
                              0,
                              0,
                              0,
                              _selectedTime!.hour,
                              _selectedTime!.minute,
                            ),
                          );
                          formKey.currentState!.validate();
                          setState(() {
                            timeController.text = formattedTime;
                          });
                        }
                      },
                      validator: (val) {
                        if (timeController.text == '') {
                          return 'Please enter the time';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final form = formKey.currentState!;
                              if (form != null) {
                                if (form.validate()) {
                                  form.save();
                                  final taskManager = TaskManager()
                                    ..description = descriptionController.text
                                    ..time = int.tryParse(timeController.text)
                                        .toString()
                                    ..date =
                                        DateTime.tryParse(dateController.text).toString();
                                  final box = Boxes.getdetails();
                                  box.add(taskManager);
                                  Navigator.of(context).pop();
                                } else {
                                  print('form not saved');
                                }
                              } else {
                                print('form is null');
                              }
                            },
                            child: const Text('Save'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   descriptionController.dispose();
  //   timeController.dispose();
  //   dateController.dispose();
  //   super.dispose();
  // }
}
