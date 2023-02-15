// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ADD A TASK',
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.displayMedium,
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
                    child: Container(
                      color: Colors.blueGrey,
                      child: TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Type...',
                          hintStyle: Theme.of(context).textTheme.displaySmall,
                          border: InputBorder.none,
                        ),
                        onSaved: (val) {
                          TaskManager().description = val;
                        },
                      ),
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
                      hintText: 'Select Date',
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDateTime(context);
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
                                  ..date =
                                      DateTime.tryParse(dateController.text);
                                final box = Boxes.getdetails();
                                box.add(taskManager);
                                Navigator.of(context).pop();
                              } else {
                                debugPrint('form not saved');
                              }
                            } else {
                              debugPrint('form is null');
                            }
                          },
                          child: Text(
                            'Save',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
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
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime combinedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        dateController.text = combinedDate.toString();
      }
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
