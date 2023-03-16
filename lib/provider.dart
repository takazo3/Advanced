import 'package:advanced/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advanced/views/edit_dialog.dart';

const List<Task> taskList = [
  Task(id: 0, description: 'Task1', isCompleted: false),
  Task(id: 1, description: 'Task2', isCompleted: false),
  Task(id: 2, description: 'Task3', isCompleted: false),
];

class TasksNotifier extends StateNotifier<List<Task>> {
  // Todo リストを空のリストとして初期化します。
  TasksNotifier() : super(taskList.cast<Task>());

  // Todo の追加
  void addTask(Task newTask) {
    state = [newTask, ...state];
  }
  

  void deleteTask(int index) {
    state = List.from(state)..removeAt(index);
  }

  void updateTask(int index, String description) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(description: description, isCompleted: false),
      ...state.sublist(index + 1),
    ];
  }

  // Todo の削除
  void removeTodo(String taskId) {
    // しつこいですが、ステートはイミュータブルです。
    // そのため既存リストを変更するのではなく、新しくリストを作成する必要があります。
    state = [
      for (final task in state)
        if (task.id != task.id) task,
    ];
  }

  // Todo の完了ステータスの変更

  void toggleCompleted(int index) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(isCompleted: !state[index].isCompleted),
      ...state.sublist(index + 1),
    ];
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final newState = List<Task>.from(state);
    newState.insert(newIndex, newState.removeAt(oldIndex));
    state = newState;
  }
}

// 最後に TodosNotifier のインスタンスを値に持つ StateNotifierProvider を作成し、
// UI 側から Todo リストを操作することを可能にします。

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
