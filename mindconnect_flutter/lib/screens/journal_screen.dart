import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';

class JournalScreen extends StatefulWidget {
  final AppStore store;
  const JournalScreen({super.key, required this.store});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String? mood;
  DateTime date = DateTime.now();

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => date = d);
  }

  Future<void> _log() async {
    if (mood == null) return;
    await widget.store.addMood(mood!, date);
    setState(() => mood = null);
    if (!mounted) return;
    final s = widget.store.streak;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s > 1 ? 'Streak: $s days! Keep it up.' : 'Mood logged.')));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final counts = widget.store.moodCounts;
        final maxCount = counts.values.fold<int>(1, (a, b) => b > a ? b : a);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('📊 Mood Journal', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Tracking your mood helps you notice patterns, understand triggers, and take '
                  'action early. It’s a powerful tool for building emotional resilience and well-being.',
                ),
              ),
            ),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Healthy Habits for Well-being', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• Adopt healthy sleep patterns'),
                  Text('• Exercise regularly'),
                  Text('• Develop coping and problem-solving skills'),
                  Text('• Connect with supportive friends and family'),
                  Text('• Practice mindfulness and self-care'),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: mood,
              decoration: const InputDecoration(
                  labelText: 'How are you feeling today?', border: OutlineInputBorder()),
              items: [for (final m in moodColors.keys) DropdownMenuItem(value: m, child: Text(m))],
              onChanged: (v) => setState(() => mood = v),
            ),
            const SizedBox(height: 8),
            Row(children: [
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(date.toIso8601String().substring(0, 10)),
              ),
              const Spacer(),
              FilledButton(onPressed: mood == null ? null : _log, child: const Text('Log Mood')),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              height: 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final e in counts.entries)
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('${e.value}'),
                        Container(
                          height: 120 * e.value / maxCount,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: moodColors[e.key],
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(e.key, style: const TextStyle(fontSize: 11)),
                      ]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(widget.store.insight))),
          ],
        );
      },
    );
  }
}
