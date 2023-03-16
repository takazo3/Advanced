import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


@immutable
class Task {
  const Task(
      {required this.id, required this.description, required this.isCompleted});

  // イミュータブルなクラスのプロパティはすべて `final` にする必要があります。
  final int id;
  final String description;
  final bool isCompleted;

  // Todo はイミュータブルであり、内容を直接変更できないためコピーを作る必要があります。
  // これはオブジェクトの各プロパティの内容をコピーして新たな Todo を返すメソッドです。
  Task copyWith({
    int? id,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class EditState extends StateNotifier<bool> {
  EditState() : super(false);

//Edit mode
  void toggleEdit() {
    state = !state;
  }
}

final editProvider =
    StateNotifierProvider<EditState, bool>((ref) => EditState());
