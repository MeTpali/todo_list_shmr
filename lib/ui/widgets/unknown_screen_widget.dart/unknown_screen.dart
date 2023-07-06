import 'package:flutter/material.dart';
import 'package:todo_list_shmr/ui/utility/localization/s.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(S.of(context).get('errorScreen')),
      ),
    );
  }
}
