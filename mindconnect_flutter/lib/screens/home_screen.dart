import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../store.dart';

class HomeScreen extends StatelessWidget {
  final AppStore store;
  final VoidCallback onStartJournal;
  const HomeScreen({super.key, required this.store, required this.onStartJournal});

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _export(BuildContext c) async {
    await Clipboard.setData(ClipboardData(text: store.exportJson()));
    if (c.mounted) _snack(c, 'Data copied to clipboard. Paste it into a file to back it up.');
  }

  Future<void> _import(BuildContext c) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: c,
      builder: (_) => AlertDialog(
        title: const Text('Import Data'),
        content: TextField(
          controller: ctrl,
          maxLines: 6,
          decoration: const InputDecoration(hintText: 'Paste exported JSON here'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Import')),
        ],
      ),
    );
    if (ok != true) return;
    final done = await store.importJson(ctrl.text);
    if (c.mounted) _snack(c, done ? 'Data imported.' : 'Invalid data.');
  }

  Future<void> _delete(BuildContext c) async {
    final ok = await showDialog<bool>(
      context: c,
      builder: (_) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text('Are you sure you want to delete all your data? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await store.clearAll();
      if (c.mounted) _snack(c, 'All data deleted.');
    }
  }

  void _privacy(BuildContext c) => showDialog(
        context: c,
        builder: (_) => AlertDialog(
          title: const Text('Privacy Audit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your data is stored only on this device:'),
              const SizedBox(height: 8),
              for (final e in store.privacySummary.entries)
                Text('• ${e.key}: ${e.value} characters'),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close'))],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: Image.asset('assets/images/logo.jpeg', height: 80)),
        const SizedBox(height: 12),
        Text('Welcome to MindConnect', style: t.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text(
          'MindConnect is a youth mental health resource hub for university students. '
          'Our mission is to create a safe, empathetic, and interactive digital space where '
          'you can manage stress, track your emotional well-being, and connect through shared experiences.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const _Quote('“You are not alone. Every step you take towards wellness matters.”'),
        Center(
          child: FilledButton(onPressed: onStartJournal, child: const Text('Start Your Mood Journal')),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/images/img1.jpeg', fit: BoxFit.cover, height: 180),
        ),
        const SizedBox(height: 16),
        const Row(children: [
          Expanded(child: _Stat('1 in 7', 'adolescents experience a mental disorder (WHO, 2025)')),
          Expanded(child: _Stat('3rd', 'leading cause of death for ages 15–29 is suicide')),
          Expanded(child: _Stat('Early Support', 'Reduces stigma and encourages help-seeking')),
        ]),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton(onPressed: () => _export(context), child: const Text('Export Data')),
            OutlinedButton(onPressed: () => _import(context), child: const Text('Import Data')),
            OutlinedButton(onPressed: () => _delete(context), child: const Text('Delete My Data')),
            OutlinedButton(onPressed: () => _privacy(context), child: const Text('Privacy Audit')),
          ],
        ),
      ],
    );
  }
}

class _Quote extends StatelessWidget {
  final String text;
  const _Quote(this.text);
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xFFE0F7FA),
          border: Border(left: BorderSide(color: Color(0xFF6A82FB), width: 4)),
        ),
        child: Text(text, style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF4F5BD5))),
      );
}

class _Stat extends StatelessWidget {
  final String big, small;
  const _Stat(this.big, this.small);
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Text(big, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(small, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ]),
        ),
      );
}
