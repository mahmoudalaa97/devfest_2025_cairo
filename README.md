# Fitness AI Agent - Flutter Firebase AI Code Lab

A Flutter application that uses Firebase AI (Gemini) to generate personalized fitness and diet plans based on user input.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up FlutterFire CLI](#setting-up-flutterfire-cli)
3. [Connecting to Firebase](#connecting-to-firebase)
4. [Enabling Firebase AI](#enabling-firebase-ai)
5. [Project Setup](#project-setup)
6. [Code Walkthrough](#code-walkthrough)
7. [Running the App](#running-the-app)

---

## Prerequisites

Before you begin, make sure you have:

- Flutter SDK installed (version 3.9.0 or higher)
- A Google account
- A Firebase project (or create one at [Firebase Console](https://console.firebase.google.com/))
- Basic knowledge of Flutter and Dart

---

## Setting Up FlutterFire CLI

The FlutterFire CLI is a command-line tool that helps you configure Firebase for your Flutter projects.

### Step 1: Install FlutterFire CLI

Open your terminal and run:

```bash
dart pub global activate flutterfire_cli
```

**Note:** Make sure `$HOME/.pub-cache/bin` is in your PATH. You can add it by running:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

To make this permanent, add it to your shell profile (`~/.zshrc` for zsh or `~/.bashrc` for bash).

### Step 2: Verify Installation

Check if FlutterFire CLI is installed correctly:

```bash
flutterfire --version
```

You should see the version number if installation was successful.

---

## Connecting to Firebase

### Step 1: Login to Firebase

Authenticate with Firebase using your Google account:

```bash
firebase login
```

This will open a browser window for you to sign in with your Google account.

### Step 2: Configure FlutterFire

Navigate to your Flutter project directory and run:

```bash
flutterfire configure
```

This command will:

1. **Detect your Firebase projects** - It will list all Firebase projects associated with your account
2. **Select platforms** - Choose which platforms you want to configure (Android, iOS, Web, macOS, Windows, Linux)
3. **Generate configuration files** - It will automatically:
   - Create `lib/firebase_options.dart` with platform-specific Firebase configuration
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Configure other platform-specific files

### Step 3: Verify Configuration

After running `flutterfire configure`, you should see:

- ✅ `lib/firebase_options.dart` file created
- ✅ Platform-specific configuration files downloaded
- ✅ Firebase project ID displayed in the terminal

**Example output:**
```
✓ Firebase project 'ai-demo-devfest' configured successfully.
✓ Generated configuration file: lib/firebase_options.dart
```

---

## Enabling Firebase AI

Firebase AI provides access to Google's Gemini models. Here's how to enable it:

### Step 1: Enable Gemini API in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Build** → **AI Studio** (or **Extensions** → **Firebase AI**)
4. Click **Get Started** or **Enable Firebase AI**
5. Accept the terms and conditions

### Step 3: Add Dependencies

Add the required packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.2.1
  firebase_ai: ^3.6.0
  flutter_riverpod: ^3.0.3
  flutter_markdown: ^0.7.4
```

Then run:

```bash
flutter pub get
```

### Step 4: Initialize Firebase in Your App

In your `main.dart`, initialize Firebase before running the app:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_demo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## Project Setup

### Step 1: Clone or Navigate to Project

```bash
cd ai_demo
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Run FlutterFire Configure (if not done already)

```bash
flutterfire configure
```

---

## Code Walkthrough

Let's explore the codebase structure and understand how each part works.

### 1. Project Structure

```
lib/
├── main.dart                    # App entry point and UI
├── firebase_options.dart        # Firebase configuration (auto-generated)
├── gemini_repository.dart       # Repository for AI interactions
├── page_controller.dart         # State management controller (duplicate, see pages/)
└── pages/
    ├── page_controller.dart     # State management controller (main one)
    ├── generating_planner_state.dart  # State definitions
    └── view_planner_page.dart   # Results display page
└── model/
    └── response.dart            # Model classes for Gemini responses (needs to be created)
```

**Note:** The `model/response.dart` file is imported but may not exist. You'll need to create it with the following structure:

```dart
class GeminiResponse {
  final List<GeminiCandidate> candidates;
  GeminiResponse({required this.candidates});
}

class GeminiCandidate {
  final GeminiContent content;
  final String? finishReason;
  GeminiCandidate({required this.content, this.finishReason});
}

class GeminiContent {
  final List<GeminiContentPart> parts;
  final String role;
  GeminiContent({required this.parts, required this.role});
}

class GeminiContentPart {
  final String text;
  GeminiContentPart({required this.text});
}
```

### 2. Firebase Options (`lib/firebase_options.dart`)

**What it does:**
This file is auto-generated by FlutterFire CLI and contains platform-specific Firebase configuration.

**Key Components:**

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Automatically selects the right configuration based on platform
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      // ... other platforms
    }
  }
  
  // Platform-specific configurations
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    projectId: '...',
    // ... other config
  );
}
```

**Why it's important:**
- Each platform (Android, iOS, Web, etc.) has different Firebase configuration
- This file centralizes all configurations
- `currentPlatform` automatically selects the right config for the running platform

### 3. Main App (`lib/main.dart`)

**What it does:**
The entry point of the application. Initializes Firebase and sets up the UI.

**Code Breakdown:**

```dart
void main() async {
  // Step 1: Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Step 2: Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Step 3: Run the app
  runApp(const MyApp());
}
```

**Key Points:**
- `WidgetsFlutterBinding.ensureInitialized()` is required before any async operations
- Firebase must be initialized before the app runs
- `DefaultFirebaseOptions.currentPlatform` automatically selects the correct config

**UI Structure:**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(  // Riverpod provider scope
      child: MaterialApp(
        home: FitnessPlannerFormPage(),  // Main form page
      ),
    );
  }
}
```

**Form Page (`FitnessPlannerFormPage`):**

This widget is a `StatefulWidget` (not `ConsumerStatefulWidget`) that collects user input:
- Age, Height, Weight (text fields)
- Gender (radio buttons using `RadioGroup<Gender>`: Male/Female)
- Activity Level (radio buttons using `RadioGroup<ActivityLevel>`: Sedentary/Lightly Active/Moderately Active)
- Goal (radio buttons using `RadioGroup<Goal>`: Lose Weight/Gain Muscle/Improve Health)

**Note:** The `RadioGroup` widget is a custom widget used for radio button groups. If this widget doesn't exist in your codebase, you'll need to either:
1. Implement a custom `RadioGroup` widget, or
2. Replace it with Flutter's standard `Radio` widgets with proper grouping using `RadioListTile`

**Generate Button Logic:**

The button uses a `Consumer` widget to watch the state and react to changes:

```dart
Consumer(
  builder: (context, ref, child) {
    // Watch the state to react to changes
    final state = ref.watch(pageControllerProvider);
    
    return ElevatedButton(
      onPressed: () async {
        // Step 1: Prevent multiple clicks while loading
        if (state is LoadingState) {
          return;
        }
        
        // Step 2: Call the state controller to generate planner
        await ref.read(pageControllerProvider.notifier)
            .generateFitnessPlanner(
              _ageController.text,
              _heightController.text,
              _weightController.text,
              _selectedGender?.name ?? "",
              _selectedActivityLevel?.name ?? "",
              _selectedGoal?.name ?? "",
            );
        
        // Step 3: Check the state and navigate or show error
        // Note: The 'state' variable is captured from the Consumer builder.
        // Since Consumer rebuilds when state changes, this should reflect
        // the updated state after the async call completes.
        // Also check 'mounted' to ensure widget is still in tree
        if (state is SuccessState && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPlannerPage(planner: state.planner),
            ),
          );
          clearAll();
        } else if (state is ErrorState && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error))
          );
        }
        clearAll();
      },
      child: state is LoadingState
          ? const CircularProgressIndicator()
          : const Text("Generate Planner and Diet Plan"),
    );
  },
)
```

**Key Points:**
- Uses `Consumer` widget to watch state changes reactively
- Prevents multiple clicks when `LoadingState` is active
- Checks `mounted` before navigation/snackbar to avoid errors if widget is disposed
- Shows loading indicator when state is `LoadingState`
- Clears form after generation attempt

### 4. State Management (`lib/pages/generating_planner_state.dart`)

**What it does:**
Defines the different states the app can be in during the AI generation process.

**State Classes:**

```dart
// Base sealed class - prevents creating new states outside this file
sealed class GeneratingPlannerState {
  const GeneratingPlannerState();
}

// Initial state - when app first loads
class InitialState extends GeneratingPlannerState {
  const InitialState();
}

// Loading state - when AI is generating response
class LoadingState extends GeneratingPlannerState {
  const LoadingState();
}

// Success state - when AI successfully generates plan
class SuccessState extends GeneratingPlannerState {
  final String planner;  // Contains the generated markdown text
  const SuccessState({required this.planner});
}

// Error state - when something goes wrong
class ErrorState extends GeneratingPlannerState {
  final String error;  // Error message
  const ErrorState({required this.error});
}
```

**Why Sealed Classes?**
- Ensures all possible states are handled
- Prevents creating invalid states
- Enables exhaustive pattern matching

### 5. Page Controller (`lib/pages/page_controller.dart`)

**What it does:**
Manages the state of the fitness planner generation process using Riverpod.

**Note:** There's also a `lib/page_controller.dart` file, but the one in `lib/pages/` is the one actually used (imported in `main.dart`). The controller imports `package:ai_demo/gemini_repository.dart` which should resolve to `lib/gemini_repository.dart`.

**Code Breakdown:**

```dart
// Riverpod provider that creates and manages the controller
final pageControllerProvider =
    StateNotifierProvider<PageController, GeneratingPlannerState>((Ref ref) {
      return PageController(FitnessPlannerRepository());
    });

class PageController extends StateNotifier<GeneratingPlannerState> {
  final FitnessPlannerRepository fitnessPlannerRepository;
  
  // Initialize with InitialState
  PageController(this.fitnessPlannerRepository) : super(InitialState());
  
  // Main method to generate fitness planner
  Future<void> generateFitnessPlanner(
    String age, String height, String weight,
    String gender, String activityLevel, String goal,
  ) async {
    // Step 1: Set state to loading (shows loading indicator)
    state = LoadingState();
    
    // Step 2: Call repository to generate plan
    final response = await fitnessPlannerRepository.generateFitnessPlanner(
      age, height, weight, gender, activityLevel, goal,
    );
    
    // Step 3: Handle response
    if (response != null) {
      // Success - extract text from response
      state = SuccessState(
        planner: response.candidates.first.content.parts.first.text,
      );
    } else {
      // Failure - set error state
      state = ErrorState(error: "Failed to generate fitness planner");
    }
  }
}
```

**State Flow:**
1. `InitialState` → User fills form
2. `LoadingState` → User clicks "Generate" button
3. `SuccessState` or `ErrorState` → AI responds

### 6. Gemini Repository (`lib/gemini_repository.dart`)

**What it does:**
Handles all interactions with Firebase AI (Gemini). This is where the magic happens!

**Important:** This file imports `package:ai_demo/model/response.dart` which defines the `GeminiResponse`, `GeminiCandidate`, `GeminiContent`, and `GeminiContentPart` classes. You'll need to create this model file if it doesn't exist.

**Code Breakdown:**

```dart
class FitnessPlannerRepository {
  Future<GeminiResponse?> generateFitnessPlanner(
    String age, String height, String weight,
    String gender, String activityLevel, String goal,
  ) async {
    try {
      // Step 1: Get the Gemini model instance
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',  // Model version
        systemInstruction: Content("System", [
          TextPart("Your name is Big Ramy and you are a fitness expert"),
        ]),
      );
```

**Key Concepts:**

1. **`FirebaseAI.googleAI()`**: Gets the Google AI (Gemini) service
2. **`generativeModel()`**: Creates a model instance
   - `model: 'gemini-2.5-flash'`: Specifies which Gemini model to use
   - `systemInstruction`: Sets the AI's personality/role (optional)

**Prompt Construction:**

```dart
      // Step 2: Build the prompt with user data
      String promptCustom = """
        You are a fitness planner.
        You are given the following information:
        - Age: $age
        - Height: $height
        - Weight: $weight
        - Gender: $gender
        - Activity Level: $activityLevel
        - Goal: $goal

        check if the age or height or weight is not a number, if so, return an error message.
        You are to generate a fitness plan and diet plan for the user.
        The fitness plan should be in a markdown format.
        The diet plan should be in a markdown format.
      """;
```

**Generating Content:**

```dart
      // Step 3: Generate content from the model
      final response = await model.generateContent([
        Content.text(promptCustom),
      ]);
```

**Response Handling:**

```dart
      // Step 4: Convert Firebase AI response to our model
      return GeminiResponse(
        candidates: [
          GeminiCandidate(
            content: GeminiContent(
              parts: [GeminiContentPart(text: response.text ?? "")],
              role: 'model',
            ),
            finishReason: response.candidates.first.finishReason?.name,
          ),
        ],
      );
```

**Error Handling:**

```dart
    } on SocketException catch (e) {
      // Handle network errors
      debugPrint(e.toString());
      return GeminiResponse(
        candidates: [
          GeminiCandidate(
            content: GeminiContent(
              parts: [
                GeminiContentPart(
                  text: 'Ops: Check your network connection!!!',
                ),
              ],
              role: 'model',
            ),
            finishReason: 'error',
          ),
        ],
      );
    }
  }
}
```

**Important Points:**
- `generateContent()` is async - it makes a network call to Gemini API
- The response contains the generated text in `response.text`
- Always handle errors (network issues, API errors, etc.)

### 7. View Planner Page (`lib/pages/view_planner_page.dart`)

**What it does:**
Displays the generated fitness plan in a beautiful markdown format.

**Code Breakdown:**

```dart
class ViewPlannerPage extends StatelessWidget {
  final String planner;  // Markdown text from AI
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Planner")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: MarkdownBody(
            data: planner,  // The markdown text
            styleSheet: MarkdownStyleSheet(
              // Custom styling for markdown elements
              p: const TextStyle(color: Colors.white, fontSize: 16),
              h1: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              // ... more styles
            ),
          ),
        ),
      ),
    );
  }
}
```

**Key Features:**
- Uses `flutter_markdown` package to render markdown
- Custom styling for headings, paragraphs, code blocks, etc.
- Scrollable view for long content

---

## Running the App

### Step 1: Ensure Dependencies are Installed

```bash
flutter pub get
```

### Step 2: Verify Firebase Configuration

Make sure `lib/firebase_options.dart` exists and contains your Firebase project configuration.

### Step 3: Run the App

For Android:
```bash
flutter run
```

For iOS:
```bash
flutter run -d ios
```

For Web:
```bash
flutter run -d chrome
```

### Step 4: Test the App

1. Fill in the form with your details:
   - Age: e.g., "25"
   - Height: e.g., "175" (in cm)
   - Weight: e.g., "70" (in kg)
   - Select gender, activity level, and goal

2. Click "Generate Planner and Diet Plan"

3. Wait for the AI to generate your personalized plan

4. View the results in markdown format

---

## Troubleshooting

### Issue: "Firebase not initialized"

**Solution:** Make sure you've run `flutterfire configure` and `Firebase.initializeApp()` is called in `main()`.

### Issue: "API key not found"

**Solution:** 
1. Check Firebase Console → Project Settings → General
2. Verify your `firebase_options.dart` has the correct API keys
3. Re-run `flutterfire configure` if needed

### Issue: "Network error" or "Connection failed"

**Solution:**
1. Check your internet connection
2. Verify Firebase AI is enabled in Firebase Console
3. Check if Gemini API is enabled in your Google Cloud project

### Issue: "Model not found"

**Solution:**
- Verify the model name in `gemini_repository.dart` is correct
- Check [Gemini API documentation](https://ai.google.dev/models/gemini) for available models


## Next Steps

- Customize the prompt to get different types of plans
- Add more user inputs (allergies, dietary restrictions, etc.)
- Save generated plans to Firebase Firestore
- Add user authentication
- Implement plan sharing features

---

## Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase AI Documentation](https://firebase.google.com/docs/ai)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Markdown Package](https://pub.dev/packages/flutter_markdown)

---

## License

This project is created for educational purposes as part of the DevFest Cairo 2025 code lab.
