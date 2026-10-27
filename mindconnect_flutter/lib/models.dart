import 'package:flutter/material.dart';

/// Mood name -> chart colour (same palette as the web version).
const Map<String, Color> moodColors = {
  'Happy': Color(0xFF81C784),
  'Sad': Color(0xFFE57373),
  'Stressed': Color(0xFFFFD54F),
  'Anxious': Color(0xFF64B5F6),
  'Calm': Color(0xFFBA68C8),
};

class MoodEntry {
  final String mood;
  final DateTime date;
  MoodEntry(this.mood, this.date);

  // Date is stored as yyyy-MM-dd, so exports from the web app import cleanly.
  Map<String, dynamic> toJson() =>
      {'mood': mood, 'date': date.toIso8601String().substring(0, 10)};

  factory MoodEntry.fromJson(Map<String, dynamic> j) => MoodEntry(
      j['mood'] as String,
      DateTime.tryParse('${j['date']}') ?? DateTime.now());
}

class Story {
  final String text;
  final DateTime date;
  Story(this.text, this.date);

  Map<String, dynamic> toJson() => {'text': text, 'date': date.toIso8601String()};

  factory Story.fromJson(Map<String, dynamic> j) =>
      Story(j['text'] as String, DateTime.tryParse('${j['date']}') ?? DateTime.now());
}

/// Same keyword check as the web app's hasTrigger().
bool hasTrigger(String text) {
  const triggers = ['suicide', 'self-harm', 'abuse', 'violence'];
  final t = text.toLowerCase();
  return triggers.any(t.contains);
}
