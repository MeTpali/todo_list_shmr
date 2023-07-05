import 'package:flutter/material.dart';
import 'package:todo_list_shmr/ui/widgets/app/todo_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final todoList = TodoList();
  runApp(todoList);
}
