import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advanced/models/todo.dart';
import 'package:advanced/provider.dart';

enum AddEdit {
  add,
  edit,
}

class EditDialog extends ConsumerWidget {
  const EditDialog({
    super.key,
    required this.addEdit,
    required this.textEditingController,
    this.index,
    this.task,
  });
  final AddEdit addEdit;
  final TextEditingController textEditingController;
  final int? index;
  final String? task;
  factory EditDialog.add() {
    return EditDialog(
      addEdit: AddEdit.add,
      textEditingController: TextEditingController(),
    );
  }

  factory EditDialog.edit(int index, String task) {
    return EditDialog(
      addEdit: AddEdit.edit,
      textEditingController: TextEditingController(),
      index: index,
      task: task,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
        child: InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: (() {
          switch (addEdit) {
            case AddEdit.add:
              return const Text('タスクを追加');
            case AddEdit.edit:
              return const Text('タスクを編集');
          }
        })(),
        content: TextField(
          keyboardType: TextInputType.text,
          controller: TextEditingController(),
          decoration: InputDecoration(hintText: 'Add task'),
          enabled: true,
          maxLength: 25,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'キャンセル'),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              String text = textEditingController.text;
              switch (addEdit) {
                case AddEdit.add:
                  ref.read(tasksProvider.notifier).addTask(
                      Task(id: 1, description: text, isCompleted: false));
                  break;
                case AddEdit.edit:
                  ref.read(tasksProvider.notifier).updateTask(index!, text);
                  break;
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          )
        ],
      ),
    ));
  }
}
