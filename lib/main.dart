// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_shmr/utility/logger/logging.dart';

import 'package:todo_list_shmr/firebase_options.dart';
import 'package:todo_list_shmr/ui/widgets/app/todo_list.dart';

class FlavorConfig {
  bool showCheckedModeBanner;

  FlavorConfig(
    this.showCheckedModeBanner,
  );
}

void mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final log = logger(MaterialApp);
  log.i('Firebase initialization started');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log.i('Firebase initialized');

  final todoList = TodoList();
  runApp(
    Provider(
      create: (context) => config,
      child: todoList,
    ),
  );
}
