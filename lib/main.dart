import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_shmr/firebase_options.dart';
import 'package:todo_list_shmr/ui/utility/logger/logging.dart';
import 'package:todo_list_shmr/ui/widgets/app/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final log = logger(MaterialApp);
  log.i('Firebase initialization started');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log.i('Firebase initialized');
  final todoList = TodoList();
  runApp(todoList);
}
