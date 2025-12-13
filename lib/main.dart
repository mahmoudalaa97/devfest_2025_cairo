import 'package:ai_demo/firebase_options.dart';
import 'package:ai_demo/page_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
        title: 'Llama Local Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final geminiResponseList = ref.watch(pageControllerProvider);

    // Scroll when new messages arrive
    if (geminiResponseList.length > _previousMessageCount) {
      _previousMessageCount = geminiResponseList.length;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Llama Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: geminiResponseList.length,
                itemBuilder: (context, index) {
                  final geminiResponse = geminiResponseList[index];
                  return Align(
                    alignment:
                        geminiResponse.candidates.first.content.role == 'model'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            geminiResponse.candidates.first.content.role ==
                                'user'
                            ? Colors.grey[900]
                            : const Color.fromARGB(255, 26, 75, 29),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: MarkdownBody(
                        data: geminiResponse
                            .candidates
                            .first
                            .content
                            .parts
                            .first
                            .text,
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
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.3,
                            ),
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
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter your prompt",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      ref
                          .read(pageControllerProvider.notifier)
                          .generateStreamText(_controller.text);
                      _controller.clear();

                      _scrollToBottom();
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.lightGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
