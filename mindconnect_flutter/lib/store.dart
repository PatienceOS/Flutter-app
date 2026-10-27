import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// Replaces the localStorage code in app.js. All data stays on the device.
class AppStore extends ChangeNotifier {
  late SharedPreferences _p;
  List<MoodEntry> moods = [];
  List<Story> stories = [];

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    moods = _decode(_p.getString('moodData'), MoodEntry.fromJson);
    stories = _decode(_p.getString('stories'), Story.fromJson);
  }

  List<T> _decode<T>(String? raw, T Function(Map<String, dynamic>) f) {
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => f(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save() async {
    await _p.setString('moodData', jsonEncode(moods.map((m) => m.toJson()).toList()));
    await _p.setString('stories', jsonEncode(stories.map((s) => s.toJson()).toList()));
    notifyListeners();
  }

  Future<void> addMood(String mood, DateTime date) {
    moods.add(MoodEntry(mood, date));
    return _save();
  }

  Future<void> addStory(String text) {
    stories.insert(0, Story(text, DateTime.now()));
    return _save();
  }

  String exportJson() => jsonEncode({
        'moodData': moods.map((m) => m.toJson()).toList(),
        'stories': stories.map((s) => s.toJson()).toList(),
      });

  Future<bool> importJson(String raw) async {
    try {
      final d = jsonDecode(raw) as Map<String, dynamic>;
      if (d['moodData'] != null) {
        moods = (d['moodData'] as List)
            .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (d['stories'] != null) {
        stories = (d['stories'] as List)
            .map((e) => Story.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      await _save();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearAll() async {
    moods = [];
    stories = [];
    await _p.clear();
    notifyListeners();
  }

  /// Consecutive days with at least one mood logged (ending today or yesterday).
  int get streak {
    final days = moods.map((m) => DateTime(m.date.year, m.date.month, m.date.day)).toSet();
    final now = DateTime.now();
    var d = DateTime(now.year, now.month, now.day);
    if (!days.contains(d)) d = DateTime(d.year, d.month, d.day - 1);
    var n = 0;
    while (days.contains(d)) {
      n++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return n;
  }

  Map<String, int> get moodCounts =>
      {for (final m in moodColors.keys) m: moods.where((e) => e.mood == m).length};

  String get insight {
    if (moods.isEmpty) return 'Log some moods to see insights!';
    final top = moodCounts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return 'Most frequent mood: ${top.key}. Keep tracking for more insights!';
  }

  /// For the Privacy Audit dialog: what is stored and how big it is.
  Map<String, int> get privacySummary => {
        'moodData': jsonEncode(moods.map((m) => m.toJson()).toList()).length,
        'stories': jsonEncode(stories.map((s) => s.toJson()).toList()).length,
      };
}
