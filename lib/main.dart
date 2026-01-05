import 'package:flutter/material.dart';
import 'data/stories.dart';
import 'screens/story_listening_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Assessment',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: StoryListeningScreen(story: stories[0]),
    );
  }
}
