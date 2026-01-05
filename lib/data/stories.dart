import '../models/story.dart'; // Story & Question models
import '../models/question.dart';

final List<Story> stories = [
  Story(
    id: "story_1",
    title: "The Image Upload Failure",
    segments: [
      "It's Monday morning. You grab your coffee and open Slack to find three messages from the support team lead, Steve.",
      "Steve says a VIP user complained over the weekend. They were trying to share a beautiful sunset photo they'd just taken at the beach. The upload progress bar moved smoothly - 20%, 40%, 60%, 80%, 95% - and then suddenly failed with a generic 'Upload failed. Please try again' message. The user tried five times. Same result every time.",
      "What's strange is this user has uploaded hundreds of photos before without issues. Steve checked their account - no problems, good standing, plenty of storage space available.",
      "You assign it to QA. By Tuesday afternoon, your QA engineer Sundar comes back with interesting findings. He says, 'I can reproduce it, but only with specific photos.' He tested with twenty different images. Photos taken fresh from the camera - failed almost every single time at 95%. But here's the weird part - screenshots uploaded perfectly. Photos from his gallery that were taken last month? No problem at all. Even videos uploaded without any issue.",
      "Sundar checked everything - WiFi was stable, cellular data was strong, the user's internet connection wasn't dropping. He even tested on different devices. Same pattern.",
      "He shows you the detailed logs. 'Look at this - fresh camera photos are taking 28-32 seconds to upload and failing right before completion. The app logs show memory warnings appearing around the same time. But gallery photos? They upload in 8-10 seconds with no memory issues.'",
      "You reach out to the backend team. They check their logs. 'Nothing changed on our end,' the backend lead confirms. 'We're receiving the uploads, processing them normally. No recent deployments, no infrastructure changes. Your timeout is set to 30 seconds on the client side, right?'",
      "You check - yes, 30-second timeout.",
      "You look at the data Sundar collected. Fresh camera photos: 8MB, 10MB, 12MB taking 28-35 seconds to upload. Gallery photos from last month: 2MB, 3MB, 4MB taking 6-10 seconds. Screenshots: 500KB, 800KB taking 2-3 seconds."
    ],
    questions: [
      Question(
        id: "s1_q1",
        text: "Based on the scenario, what is the most likely reason the upload fails?",
        type: QuestionType.singleChoice,
        options: [
          "The selected images have significantly larger dimensions and data size, leading to higher memory usage or upload timeout before completion.",
          "The application lacks sufficient permission to access certain image files at runtime",
          "The image encoding format used by the device is incompatible with the upload pipeline",
          "The backend enforces a strict maximum file size and rejects requests that exceed it",
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s1_q2",
        text: "What is the most robust solution to prevent this issue while keeping the user experience smooth?",
        type: QuestionType.singleChoice,
        options: [
          "Optimize images on the client before upload by reducing size while maintaining acceptable visual quality.",
          "Restrict uploads by notifying users when selected media exceeds supported limits",
          "Allow large uploads to continue in the background with extended timeouts",
          "Programmatically lower the image capture quality to avoid large files",
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s1_q3",
        text: "After compression fix, new issue: Portrait photos appear sideways/upside-down. What should be done?",
        type: QuestionType.multiChoice,
        options: [
          "Normalize image orientation by reading orientation metadata and physically rotating the image pixels before upload.",
          "Ensure orientation-related metadata is preserved or reapplied after image compression.",
          "Convert all images to a fixed orientation (for example, landscape) during preprocessing",
          "Detect incorrect orientation on the server and apply automatic rotation",
        ],
        correctAnswers: {0, 1},
      ),
    ],
  ),

  // Add Story 2
  Story(
    id: "story_2",
    title: "The Crash on Background Return",
    segments: [
      "It's sprint planning week. Your video streaming app just released version 3.2 with some UI improvements and bug fixes. Nothing related to the video player itself - that code hasn't been touched in months.",
      "Tuesday morning, your product manager, Satya, pulls you into a meeting. 'We're getting crash reports. Not a huge number yet, but they're all showing the same pattern.'",
      "He shares the Crashlytics dashboard. About 50 crashes in the past 24 hours. All with the same stack trace - NullPointerException in video player initialization. But here's what's confusing: these aren't happening on app launch. They're happening when users return to the app.",
      "Your QA engineer, Jensen, has been investigating. He says, 'I found a reliable way to reproduce it. Let me show you.' He opens the app on his test device, starts playing a video. The video plays smoothly. Then he presses the home button and opens Instagram. He scrolls through Instagram for about two minutes. Then he switches back to your app.",
      "Crash. The app completely terminates.",
      "'But watch this,' Jensen says. He repeats the test, but this time switches back after only 20 seconds. The video resumes perfectly. No crash.",
      "You ask him to try different timing intervals. Under 30 seconds - works fine. Over one minute - crashes consistently. Between 30 seconds and one minute - sometimes crashes, sometimes doesn't.",
      "Satya asks, 'Is this an Instagram issue? Something they're doing that interferes with our app?' Jensen shakes his head. 'I tested with other apps too - Chrome, Twitter, Gmail. Same behavior. It's not about which app they switch to. It's about how long they stay away.'",
      "You check the device memory stats during testing. When Jensen switches apps and stays away for 2-3 minutes, you notice the Android system is reclaiming memory from backgrounded apps. Your app's memory footprint drops significantly.",
      "The crash logs show the error happening specifically in the video player initialization code when trying to resume playback. The video player instance is being referenced, but something about it is null."
    ],
    questions: [
      Question(
        id: "s2_q1",
        text: "Most likely root cause of the crash?",
        type: QuestionType.singleChoice,
        options: [
          "Some components involved in video playback are no longer in a valid state when the app returns to the foreground.",
          "The video decoding mechanism stops functioning correctly after being paused beyond a certain duration.",
          "Playback fails because the app loses connectivity while it is not active",
          "Another application disrupts video playback when users switch between apps"
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s2_q2",
        text: "Most appropriate solution to prevent this crash?",
        type: QuestionType.singleChoice,
        options: [
          "Validate video player state during app resume and recreate any components that may have been released by the system.",
          "Keep the video player active while the app is backgrounded to prevent the system from reclaiming resources",
          "Abort playback and show an error message whenever the app resumes from the background",
          "Request system-level privileges to prevent the OS from terminating background resources"
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s2_q3",
        text: "New problem after fixing: call interrupts playback, audio resumes but screen remains black. Cause?",
        type: QuestionType.multiChoice,
        options: [
          "The video rendering surface used by the player was released during the call and was not recreated when the app returned to the foreground.",
          "The audio and video playback pipelines transitioned through different lifecycle states during the interruption, leading to an inconsistent resume state.",
          "The telephony subsystem takes exclusive control over media resources, preventing video playback from resuming correctly",
          "The display subsystem fails to refresh the UI after prolonged background interruptions"
        ],
        correctAnswers: {0, 1},
      ),
    ],
  ),

  // Add Story 3
  Story(
    id: "story_3",
    title: "The Offline Queue Chaos",
    segments: [
      "Your team just shipped a major feature last month - offline support for your social media app. Users can now like posts, comment, and share even without internet. Everything gets queued locally and syncs automatically when connection is restored. Product and marketing are excited. Early adoption looks good.",
      "It's Wednesday afternoon. You're reviewing pull requests when Mark from customer support sends an urgent Slack message with a screen recording attached.",
      "Mark writes: 'Got a confusing ticket. User went on a long flight yesterday - completely offline for 6 hours but stayed active on the app the whole time. They're a power user.'",
      "He shares what the user did while offline: Liked post A. Scrolled through feed. Commented 'Great shot!' on post B. Kept scrolling. Unliked post A because they accidentally double-tapped. Liked post C. Scrolled more. Saw post B again in their feed. Commented again: 'Really love this!' on the same post B.",
      "So five actions total: like post A, comment on B, unlike A, like C, comment on B again.",
      "Mark continues: 'When they landed and got WiFi, the app synced everything automatically like it's supposed to. But now the user is confused and frustrated.'",
      "He shares screenshots from the user. Post B shows their comment 'Great shot!' appearing twice in the comments section - duplicated. And post A? It shows a like from this user, even though they specifically unliked it.",
      "You check the offline queue logs. All five actions were queued correctly. Timestamps look right. When the user came online, the queue processed all five actions in order and sent them to the backend.",
      "Your backend colleague Tim confirms: 'We received all five requests. All returned 200 OK. No errors on our side. Everything was processed successfully as far as we can tell.'",
      "But somehow, the final state is wrong. The unlike action didn't override the previous like. The second comment on post B got created as a duplicate instead of being handled intelligently.",
      "You test the queue logic yourself. Queue just processes actions sequentially in FIFO order - first in, first out. No intelligence, no deduplication, no conflict handling. It's just blindly sending whatever is queued."
    ],
    questions: [
      Question(
        id: "s3_q1",
        text: "What went wrong with the queue processing?",
        type: QuestionType.singleChoice,
        options: [
          "Actions affecting the same content were processed sequentially without considering how later actions should override earlier ones.",
          "One of the queued actions failed during synchronization due to a transient error",
          "Requests were delivered to the backend in an incorrect order",
          "The backend rejected certain actions because of missing authentication"
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s3_q2",
        text: "How should the offline queue be designed to prevent this?",
        type: QuestionType.singleChoice,
        options: [
          "Combine or cancel logically conflicting actions on the same entity before syncing them to the server.",
          "Send all queued actions exactly as recorded to preserve a complete history of user activity",
          "Increase retry attempts so all actions eventually succeed",
          "Delay synchronization until the user manually confirms it"
        ],
        correctAnswers: {0},
      ),
      Question(
        id: "s3_q3",
        text: "Edge case: user liked post A, owner deleted it, queue tries to sync. How to handle?",
        type: QuestionType.multiChoice,
        options: [
          "All synchronization failures are treated as temporary and retried indefinitely",
          "Responses indicating client-side invalidity should be handled differently from transient server or network errors.",
          "Users should be informed when an offline action can no longer be applied and allowed to dismiss it.",
          "Retry attempts should be bounded to avoid endless synchronization loops."
        ],
        correctAnswers: {1, 2, 3},
      ),
    ],
  ),
];
