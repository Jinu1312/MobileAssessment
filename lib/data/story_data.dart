import '../models/story_segment.dart';

final List<StorySegment> storySegments = [
  StorySegment(
    index: 0,
    text:
    "It's Friday afternoon. Sarah from marketing just launched a flash sale campaign with emails linking to product 12345: myapp://product/12345",
  ),
  StorySegment(
    index: 1,
    text: "Within minutes, Customer Support reports a strange issue.",
  ),
  StorySegment(
    index: 2,
    text:
    "User A complains: I clicked the link, app opened but showed home screen, not the product!",
  ),
  StorySegment(
    index: 3,
    text:
    "User B reports: Weird, when I clicked the same link while the app was already open in the background, it worked perfectly and showed product 12345.",
  ),
  StorySegment(
    index: 4,
    text:
    "Sarah tests it herself. It works fine for her. She forwards everything to you, the mobile lead.",
  ),
  StorySegment(
    index: 5,
    text:
    "You notice the pattern: App completely closed leads to Home screen. App in background means deep link works perfectly.",
  ),
  StorySegment(
    index: 6,
    text: "What's happening here?",
  ),
];
