import 'package:advanced/provider.dart';
import 'package:advanced/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advanced/views/edit_dialog.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> taskList = ref.watch(tasksProvider);
    final isEdit = ref.watch(editProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        actions: [
          isEdit
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => ref.read(editProvider.notifier).toggleEdit(),
                )
              : IconButton(
                  icon: const Icon(Icons.mode_edit),
                  onPressed: () => ref.read(editProvider.notifier).toggleEdit(),
                ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        header: isEdit
            ? InkWell(
                child: Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    child: ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add a Task'),
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) {
                            return EditDialog.add();
                          }),
                    )),
              )
            : null,
        footer: isEdit
            ? InkWell(
                child: Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    child: ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add a Task'),
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) {
                            return EditDialog.add();
                          }),
                    )),
              )
            : null,
        children: [
          for (int index = 0; index < taskList.length; index++)
            Material(
              key: Key('$index'),
              child: InkWell(
                  onTap: () {
                    ref.read(tasksProvider.notifier).toggleCompleted(index);
                  },
                  child: Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        taskList[index].description,
                        style: taskList[index].isCompleted
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey)
                            : null,
                      ),
                      onTap: () {
                        isEdit
                            ? showDialog(
                                context: context,
                                builder: (_) {
                                  return EditDialog.edit(
                                      index, taskList[index].description);
                                },
                              )
                            : ref
                                .read(tasksProvider.notifier)
                                .toggleCompleted(index);
                      },
                      trailing: isEdit
                          ? IconButton(
                              onPressed: () => ref
                                  .read(tasksProvider.notifier)
                                  .deleteTask(index),
                              icon: const Icon(Icons.clear, color: Colors.red))
                          : (taskList[index].isCompleted
                              ? const Icon(Icons.check, color: Colors.green)
                              : null),
                    ),
                  )),
            )
        ],
        onReorder: (int oldIndex, int newIndex) {
          ref.read(tasksProvider.notifier).reorderTask(oldIndex, newIndex);
        },
      ),
    );
  }
}
