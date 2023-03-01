// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_manager/database_modal/database_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';

class EditTaskForm extends StatefulWidget {
  final TaskManager? values;
  final Function(
    String title,
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
  TextEditingController titleController = TextEditingController();
  DateTime? scheduleTime;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.values != null) {
      final tasks = widget.values!;
      titleController.text = tasks.description!;
      descriptionController.text = tasks.description!;
      dateController.text = tasks.date!.toString();
      debugPrint('${tasks.date!}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'EDIT A TASK',
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xffECE7FF),
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: titleController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Untitled',
                      hintStyle: Theme.of(context).textTheme.displaySmall,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onSaved: (val) {
                      TaskManager().title = val;
                    },
                    validator: (val) {
                      if (titleController.text == '') {
                        return 'Please enter the title';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Type...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSaved: (val) {
                        TaskManager().description = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Select Date',
                    ),
                    readOnly: true,
                    onTap: () {
                      // _selectDateTime(context);
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {
                          scheduleTime = date;
                          dateController.text = scheduleTime.toString();
                        },
                        onConfirm: (date) {},
                      );
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
    );
  }

  Widget buildAddButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Add'),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          final title = titleController.text;
          final description = descriptionController.text;
          final date = DateTime.tryParse(dateController.text);
          widget.onClickedDone(title, description, date!);
          NotificationService().scheduleNotification(
            title: title,
            body: description,
            scheduledNotificationDateTime: date,
          );
          Navigator.of(context).pop();
        }
      },
    );
  }
}
