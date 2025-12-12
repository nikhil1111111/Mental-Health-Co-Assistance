import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalEntry {
  final String mood;
  final String text;
  final DateTime createdAt;

  const JournalEntry({
    required this.mood,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      mood: json['mood'] as String? ?? '',
      text: json['text'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class GratitudeEntry {
  final List<String> items;
  final DateTime createdAt;

  const GratitudeEntry({
    required this.items,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'items': items,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GratitudeEntry.fromJson(Map<String, dynamic> json) {
    final list = json['items'];
    return GratitudeEntry(
      items: list is List ? list.map((e) => e.toString()).toList() : <String>[],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class WellnessProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isInitialized = false;
  bool _darkMode = false;
  bool _completedOnboarding = false;
  final List<JournalEntry> _journalEntries = [];
  final List<GratitudeEntry> _gratitudeEntries = [];

  bool get isInitialized => _isInitialized;
  bool get darkMode => _darkMode;
  bool get completedOnboarding => _completedOnboarding;
  List<JournalEntry> get journalEntries => List.unmodifiable(_journalEntries);
  List<GratitudeEntry> get gratitudeEntries => List.unmodifiable(_gratitudeEntries);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _darkMode = _prefs.getBool('darkMode') ?? false;
    _completedOnboarding = _prefs.getBool('completedOnboarding') ?? false;
    _restoreJournal();
    _restoreGratitude();
    _isInitialized = true;
    notifyListeners();
  }

  void setOnboardingComplete() {
    _completedOnboarding = true;
    _prefs.setBool('completedOnboarding', true);
    notifyListeners();
  }

  void toggleDarkMode(bool enabled) {
    _darkMode = enabled;
    _prefs.setBool('darkMode', enabled);
    notifyListeners();
  }

  void addJournalEntry(String text, String mood) {
    final entry = JournalEntry(
      mood: mood,
      text: text,
      createdAt: DateTime.now(),
    );
    _journalEntries.insert(0, entry);
    _persistJournal();
    notifyListeners();
  }

  void addGratitudeEntry(List<String> items) {
    final trimmed = items.where((item) => item.trim().isNotEmpty).toList();
    if (trimmed.isEmpty) return;
    final entry = GratitudeEntry(
      items: trimmed,
      createdAt: DateTime.now(),
    );
    _gratitudeEntries.insert(0, entry);
    _persistGratitude();
    notifyListeners();
  }

  void _restoreJournal() {
    final raw = _prefs.getString('journalEntries');
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _journalEntries
          ..clear()
          ..addAll(decoded.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)));
      }
    } catch (_) {
      // If parsing fails, skip restoring to avoid crashes.
    }
  }

  void _restoreGratitude() {
    final raw = _prefs.getString('gratitudeEntries');
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _gratitudeEntries
          ..clear()
          ..addAll(decoded.map((e) => GratitudeEntry.fromJson(e as Map<String, dynamic>)));
      }
    } catch (_) {
      // If parsing fails, skip restoring to avoid crashes.
    }
  }

  void _persistJournal() {
    final payload = jsonEncode(_journalEntries.map((e) => e.toJson()).toList());
    _prefs.setString('journalEntries', payload);
  }

  void _persistGratitude() {
    final payload = jsonEncode(_gratitudeEntries.map((e) => e.toJson()).toList());
    _prefs.setString('gratitudeEntries', payload);
  }
}
