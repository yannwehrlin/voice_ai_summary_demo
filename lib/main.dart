import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_ai_summary_demo/visits/visits_controller.dart';

void main() {
  runApp(const ProviderScope(overrides: [], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bilan de visite'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final review = ref.read(reviewProvider);
    if (review != null) _textController.text = review;
    // _textController.addListener(() {
    //   ref.read(reviewProvider.notifier).state = _textController.text;
    // });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isListening = ref.watch(isListeningProvider);
    final review = ref.watch(reviewProvider);
    _textController.text = review ?? "";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: (isListening == true)
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height:
                                24.0, // ensure the indicator fits well in the button
                            width: 24.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ))
                      : const Icon(Icons.mic),
                  onPressed: () {
                    ref.read(reviewProvider.notifier).state = null;
                    (isListening == true)
                        ? null
                        : ref
                            .read(visitsControllerProvider.notifier)
                            .reviewVisit();
                    FocusScope.of(context).requestFocus(_textFocusNode);
                  },
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    focusNode: _textFocusNode,
                    minLines: 5,
                    maxLines: 30,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'bilan de la visite...',
                    ),
                    controller: _textController,
                    onChanged: (value) {
                      ref.read(reviewProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Enregistrer')],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
