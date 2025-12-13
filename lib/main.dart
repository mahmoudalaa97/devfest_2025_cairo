import 'package:ai_demo/firebase_options.dart';
import 'package:ai_demo/pages/page_controller.dart';
import 'package:ai_demo/pages/generating_planner_state.dart';
import 'package:ai_demo/pages/view_planner_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
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
        home: FitnessPlannerFormPage(),
      ),
    );
  }
}

enum Gender { female, male }

enum ActivityLevel { sedentary, lightlyActive, moderatelyActive }

enum Goal { loseWeight, gainMuscle, improveHealth }

class FitnessPlannerFormPage extends StatefulWidget {
  const FitnessPlannerFormPage({super.key});

  @override
  State<FitnessPlannerFormPage> createState() => _FitnessPlannerFormPageState();
}

class _FitnessPlannerFormPageState extends State<FitnessPlannerFormPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Gender? _selectedGender = Gender.male;
  ActivityLevel? _selectedActivityLevel = ActivityLevel.sedentary;
  Goal? _selectedGoal = Goal.loseWeight;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();

    super.dispose();
  }

  void clearAll() {
    _ageController.clear();
    _heightController.clear();
    _weightController.clear();
    _selectedGender = Gender.male;
    _selectedActivityLevel = ActivityLevel.sedentary;
    _selectedGoal = Goal.loseWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitnes AI Agent")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Selected Age: "),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      hintText: "Enter your age",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Selected Height: "),
                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      hintText: "Enter your height",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Selected Weight: "),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      hintText: "Enter your weight",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender selection widget
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RadioGroup<Gender>(
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        _selectedGender = value;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Select your gender: '),
                          const ListTile(
                            title: Text('Male'),
                            leading: Radio<Gender>(value: Gender.male),
                          ),
                          const ListTile(
                            title: Text('Female'),
                            leading: Radio<Gender>(value: Gender.female),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Activity level selection widget
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RadioGroup<ActivityLevel>(
                      groupValue: _selectedActivityLevel,
                      onChanged: (ActivityLevel? value) {
                        _selectedActivityLevel = value;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Select your activity level: '),
                          const ListTile(
                            title: Text('Sedentary'),
                            leading: Radio<ActivityLevel>(
                              value: ActivityLevel.sedentary,
                            ),
                          ),
                          const ListTile(
                            title: Text('Lightly active'),
                            leading: Radio<ActivityLevel>(
                              value: ActivityLevel.lightlyActive,
                            ),
                          ),
                          const ListTile(
                            title: Text('Moderately active'),
                            leading: Radio<ActivityLevel>(
                              value: ActivityLevel.moderatelyActive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Goal selection widget
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RadioGroup<Goal>(
                      groupValue: _selectedGoal,
                      onChanged: (Goal? value) {
                        _selectedGoal = value;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Select your goal: '),
                          const ListTile(
                            title: Text('Lose weight'),
                            leading: Radio<Goal>(value: Goal.loseWeight),
                          ),
                          const ListTile(
                            title: Text('Gain muscle'),
                            leading: Radio<Goal>(value: Goal.gainMuscle),
                          ),
                          const ListTile(
                            title: Text('Improve health'),
                            leading: Radio<Goal>(value: Goal.improveHealth),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(pageControllerProvider);
                    return ElevatedButton(
                      onPressed: () async {
                        if (state is LoadingState) {
                          return;
                        }
                        await ref
                            .read(pageControllerProvider.notifier)
                            .generateFitnessPlanner(
                              _ageController.text,
                              _heightController.text,
                              _weightController.text,
                              _selectedGender?.name ?? "",
                              _selectedActivityLevel?.name ?? "",
                              _selectedGoal?.name ?? "",
                            );
                        if (state is SuccessState && mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewPlannerPage(planner: state.planner),
                            ),
                          );
                          clearAll();
                        } else if (state is ErrorState && mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        }
                        clearAll();
                      },
                      child: state is LoadingState
                          ? const CircularProgressIndicator()
                          : const Text("Generate Planner and Diet Plan"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
