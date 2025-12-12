import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wellness_provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _moods = const ['Grounded', 'Hopeful', 'Okay', 'Low', 'Anxious'];
  String _selectedMood = 'Okay';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<WellnessProvider>().addJournalEntry(text, _selectedMood);
    _controller.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<WellnessProvider>().journalEntries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capture what\'s on your mind. A quick note can help you track patterns.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Mood:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedMood,
                  items: _moods
                      .map((mood) => DropdownMenuItem<String>(
                            value: mood,
                            child: Text(mood),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedMood = value ?? _selectedMood),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Write a few sentences...',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submit(context),
                child: const Text('Save entry'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: entries.isEmpty
                  ? const Center(child: Text('No entries yet.'))
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(entry.mood),
                            subtitle: Text(entry.text),
                            trailing: Text(
                              _formatDate(entry.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) {
      return 'Today';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
