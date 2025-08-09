import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/page/main_page.dart';

void main() => runApp(const FMCLBaseApp());


class FMCLBaseApp extends StatelessWidget {
  const FMCLBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Minecraft Launcher',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        fontFamily: 'Noto Sans SC', // Use NotoSans
      ),

      home: HomePage(),
    );
  }
}
