import 'package:flutter/material.dart';
import 'package:bonevision/screens/start_screen.dart';
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartScreen());
  }
}
