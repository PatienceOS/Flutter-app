import 'package:flutter/material.dart';
import 'screens/forum_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/newsletter_screen.dart';
import 'screens/resources_screen.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = AppStore();
  await store.load();
  runApp(MindConnectApp(store: store));
}

class MindConnectApp extends StatelessWidget {
  final AppStore store;
  const MindConnectApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MindConnect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A82FB)),
          useMaterial3: true,
        ),
        home: Shell(store: store),
      );
}

class Shell extends StatefulWidget {
  final AppStore store;
  const Shell({super.key, required this.store});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(store: widget.store, onStartJournal: () => setState(() => index = 1)),
      JournalScreen(store: widget.store),
      ForumScreen(store: widget.store),
      const ResourcesScreen(),
      const NewsletterScreen(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('MindConnect')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
          ),
        ),
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), label: 'Forum'),
          NavigationDestination(icon: Icon(Icons.link), label: 'Resources'),
          NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Newsletter'),
        ],
      ),
    );
  }
}
