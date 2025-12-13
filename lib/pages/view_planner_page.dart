import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ViewPlannerPage extends StatelessWidget {
  const ViewPlannerPage({super.key, required this.planner});
  final String planner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Planner")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: MarkdownBody(
            data: planner,
            styleSheet: MarkdownStyleSheet(
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
                backgroundColor: Colors.black.withOpacity(0.3),
                fontFamily: 'monospace',
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
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
