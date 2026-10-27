import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';

class ForumScreen extends StatefulWidget {
  final AppStore store;
  const ForumScreen({super.key, required this.store});
  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    await widget.store.addStory(text);
    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final stories = widget.store.stories.take(10).toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('💬 Peer Story Forum', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Forum Guidelines', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• Be respectful and supportive'),
                  Text('• Share experiences, not diagnoses'),
                  Text('• No hate speech, bullying, or discrimination'),
                  Text('• Posts are anonymous—protect your privacy'),
                  Text('• If you need urgent help, see our Resources page'),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your experience or coping tip...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _post, child: const Text('Post Anonymously')),
            ),
            const SizedBox(height: 8),
            for (final s in stories) _StoryTile(story: s),
          ],
        );
      },
    );
  }
}

class _StoryTile extends StatefulWidget {
  final Story story;
  const _StoryTile({required this.story});
  @override
  State<_StoryTile> createState() => _StoryTileState();
}

class _StoryTileState extends State<_StoryTile> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.story;
    final date = s.date.toIso8601String().substring(0, 10);
    final hidden = hasTrigger(s.text) && !revealed;
    return Card(
      child: ListTile(
        title: hidden
            ? const Text('Trigger Warning',
                style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold))
            : Text(s.text), // Text() never interprets HTML, so no XSS risk
        subtitle: hidden ? null : Text(date),
        trailing: hidden
            ? TextButton(onPressed: () => setState(() => revealed = true), child: const Text('View'))
            : null,
      ),
    );
  }
}
