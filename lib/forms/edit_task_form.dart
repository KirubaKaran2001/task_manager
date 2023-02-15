// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_modal/database_modal.dart';

class EditTaskForm extends StatefulWidget {
  final TaskManager? values;
  final Function(
    String description,
    DateTime date,
  ) onClickedDone;

  const EditTaskForm({
    Key? key,
    this.values,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _EditTaskFormState createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.values != null) {
      final tasks = widget.values!;
      descriptionController.text = tasks.description!;
      dateController.text = tasks.date!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        hintText: 'Select Date',
                      ),
                      readOnly: true,
                      // onTap: () async {
                      //   DateTime? pickedDate = await showDatePicker(
                      //     context: context,
                      //     initialDate: DateTime.now(),
                      //     firstDate: DateTime.now(),
                      //     lastDate: DateTime(2100),
                      //   );
                      //   if (pickedDate != null) {
                      //     String formattedDate = DateFormat('yyyy-MM-dd')
                      //         .add_jms()
                      //         .format(pickedDate);
                      //     setState(() {
                      //       dateController.text = formattedDate;
                      //     });
                      //   } else {
                      //     debugPrint("Date is not selected");
                      //   }
                      // },
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
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildAddButton(context),
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

  Widget buildAddButton(BuildContext context) {
    return TextButton(
      child: const Text('Add'),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          final description = descriptionController.text;
          final date = DateTime.tryParse(dateController.text);
          widget.onClickedDone(description, date!);
          Navigator.of(context).pop();
        }
      },
    );
  }
}
