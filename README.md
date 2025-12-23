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
  cupertino_icons: ^1.0.8
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
git clone https://github.com/mahmoudalaa97/devfest_2025_cairo.git
cd devfest_2025_cairo
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Run FlutterFire Configure (if not done already)

```bash
flutterfire configure
```

### Step 4: Create RadioGroup Widget (if needed)

If you encounter errors about `RadioGroup` not being defined, create a custom widget. You can either:

---

## Code Walkthrough

Let's explore the codebase structure and understand how each part works.

### 1. Project Structure

```
lib/
├── main.dart                    # App entry point and Firebase initialization
├── firebase_options.dart        # Firebase configuration (auto-generated)
└── modules/
    └── generate_fitnes_plan/
        ├── repositories/
        │   └── generating_planner_repository.dart  # Repository for AI interactions
        └── ui/
            ├── generating_planner_page.dart        # Main form page
            ├── generating_planner_state.dart       # State definitions
            ├── generating_planner_controller.dart  # State management controller
            └── view_planner_page.dart              # Results display page
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(  // Riverpod provider scope
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fitnes AI Agent',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const GeneratingPlannerPage(),  // Main form page
      ),
    );
  }
}
```

**Form Page (`GeneratingPlannerPage`):**

This widget is a `StatefulWidget` that collects user input:
- Age, Height, Weight (text fields using `TextFormField`)
- Gender (radio buttons using `RadioGroup<Gender>`: Male/Female)
- Activity Level (radio buttons using `RadioGroup<ActivityLevel>`: Sedentary/Lightly Active/Moderately Active)
- Goal (radio buttons using `RadioGroup<Goal>`: Lose Weight/Gain Muscle/Improve Health)

**Important Notes:**

1. **RadioGroup Widget**: The `RadioGroup` widget is used in the code but may not be defined. You'll need to either:
   - Implement a custom `RadioGroup` widget that wraps `Radio` widgets with proper grouping
   - Replace it with Flutter's standard `RadioListTile` widgets grouped using `Radio` with a common `groupValue`

2. **Enums**: The page uses three enums defined in the same file:
   - `Gender` (female, male)
   - `ActivityLevel` (sedentary, lightlyActive, moderatelyActive)
   - `Goal` (loseWeight, gainMuscle, improveHealth)

**Generate Button Logic:**

The button uses a `Consumer` widget to watch the state and react to changes:

```dart
SizedBox(
  height: 60,
  child: Consumer(
    builder: (context, ref, child) {
      final state = ref.watch(generatingPlannerController);
      return ElevatedButton(
        onPressed: () async {
          // Step 1: Prevent multiple clicks while loading
          if (state is LoadingState) {
            return;
          }
          
          // Step 2: Call the state controller to generate planner
          await ref.read(generatingPlannerController.notifier)
              .generateFitnesPlanner(
                _ageController.text,
                _heightController.text,
                _weightController.text,
                _selectedGender?.name ?? "",
                _selectedActivityLevel?.name ?? "",
                _selectedGoal?.name ?? "",
              );
          
          // Step 3: Check the state and navigate or show error
          // Note: Since Consumer rebuilds when state changes, the 'state' variable
          // will reflect the updated state after the async call completes
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
  ),
)
```

**Key Points:**
- Uses `Consumer` widget to watch state changes reactively
- Prevents multiple clicks when `LoadingState` is active
- The `Consumer` widget automatically rebuilds when state changes, so the `state` variable will reflect the latest state
- Checks `mounted` before navigation/snackbar to avoid errors if widget is disposed
- Shows loading indicator when state is `LoadingState`
- Clears form after generation attempt

**Note:** In the current implementation, the state check happens after the async call. Since `Consumer` rebuilds when the state changes, the `state` variable in the builder will be updated. However, for more reliable state handling, you could read the state again after the async call: `final updatedState = ref.read(generatingPlannerController);`

### 4. State Management (`lib/modules/generate_fitnes_plan/ui/generating_planner_state.dart`)

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

### 5. Generating Planner Controller (`lib/modules/generate_fitnes_plan/ui/generating_planner_controller.dart`)

**What it does:**
Manages the state of the fitness planner generation process using Riverpod.

**Code Breakdown:**

```dart
// Riverpod provider that creates and manages the controller
final generatingPlannerController =
    StateNotifierProvider<GeneratingPlannerController, GeneratingPlannerState>((
      Ref ref,
    ) {
      return GeneratingPlannerController(GeneratingPlannerRepository());
    });

class GeneratingPlannerController
    extends StateNotifier<GeneratingPlannerState> {
  final GeneratingPlannerRepository generatingPlannerRepository;
  
  // Initialize with InitialState
  GeneratingPlannerController(this.generatingPlannerRepository)
      : super(InitialState());
  
  // Main method to generate fitness planner
  Future<void> generateFitnesPlanner(
    String age, String height, String weight,
    String gender, String activityLevel, String goal,
  ) async {
    // Step 1: Set state to loading (shows loading indicator)
    state = LoadingState();
    
    // Step 2: Call repository to generate plan
    final response = await generatingPlannerRepository.generateFitnesPlanner(
      age, height, weight, gender, activityLevel, goal,
    );
    
    // Step 3: Handle response
    if (response != null) {
      // Success - response is already a String
      state = SuccessState(planner: response);
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

### 6. Generating Planner Repository (`lib/modules/generate_fitnes_plan/repositories/generating_planner_repository.dart`)

**What it does:**
Handles all interactions with Firebase AI (Gemini). This is where the magic happens!

**Code Breakdown:**

```dart
class GeneratingPlannerRepository {
  GeneratingPlannerRepository();

  Future<String?> generateFitnesPlanner(
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

**Generating Content and Response Handling:**

```dart
      // Step 3: Generate content from the model and return the text directly
      final GenerateContentResponse response = await model.generateContent([
        Content.text(promptCustom),
      ]);
      return response.text;  // Returns String? directly
```

**Error Handling:**

```dart
    } on SocketException catch (e) {
      // Handle network errors
      debugPrint(e.toString());
      return 'Ops: Check your network connection!!!';
    }
  }
}
```

**Important Points:**
- `generateContent()` is async - it makes a network call to Gemini API
- The response contains the generated text in `response.text`
- The repository returns `String?` directly (simplified from previous model structure)
- Always handle errors (network issues, API errors, etc.)

### 7. View Planner Page (`lib/modules/generate_fitnes_plan/ui/view_planner_page.dart`)

**What it does:**
Displays the generated fitness plan in a beautiful markdown format.

**Code Breakdown:**

```dart
class ViewPlannerPage extends StatelessWidget {
  const ViewPlannerPage({super.key, required this.planner});
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
              h2: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              h3: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              code: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                fontFamily: 'monospace',
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              blockquote: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              listBullet: const TextStyle(color: Colors.white),
              strong: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              em: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
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

### Step 2: Verify Required Files Exist

Make sure the following files exist:
- ✅ `lib/firebase_options.dart` - Firebase configuration (auto-generated)

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
- Verify the model name in `generating_planner_repository.dart` is correct
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
