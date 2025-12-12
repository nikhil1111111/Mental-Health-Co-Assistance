import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wellness_provider.dart';

class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({super.key});

  @override
  State<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends State<GratitudeScreen> {
  final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    final items = _controllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
    if (items.isEmpty) return;
    context.read<WellnessProvider>().addGratitudeEntry(items);
    for (final controller in _controllers) {
      controller.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gratitude noted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<WellnessProvider>().gratitudeEntries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List three small things you appreciate today.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            ...List.generate(_controllers.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index == _controllers.length - 1 ? 0 : 8),
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    hintText: 'Grateful for...',
                    prefixIcon: Text('${index + 1}.', style: Theme.of(context).textTheme.bodyMedium),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: entries.isEmpty
                  ? const Center(child: Text('No gratitude entries yet.'))
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Wrap(
                              spacing: 8,
                              children: entry.items.map((item) => Chip(label: Text(item))).toList(),
                            ),
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
    if (now.difference(date).inDays == 0) return 'Today';
    return '${date.day}/${date.month}/${date.year}';
  }
}
