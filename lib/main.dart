import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_assessment/ui/story_listening_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ensures services like SystemChrome work
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StoryListeningScreenWrapper(),
    );
  }
}

// Wrapper widget to apply status bar style per screen
class StoryListeningScreenWrapper extends StatelessWidget {
  const StoryListeningScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Force white icons on dark background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // dark background shows
        statusBarIconBrightness: Brightness.light, // Android: white icons
        statusBarBrightness: Brightness.dark, // iOS: white icons
      ),
    );
    return StoryListeningScreen(storyIndex: 0,results: [],);
  }
}