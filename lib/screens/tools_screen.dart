import 'package:flutter/material.dart';
import 'breathing_screen.dart';
import 'gratitude_screen.dart';
import 'grounding_screen.dart';
import 'journal_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _Tool(
        title: 'Breathing exercise',
        description: '4-7-8 guided timer to slow breathing.',
        builder: (_) => const BreathingScreen(),
      ),
      _Tool(
        title: 'Journal',
        description: 'Write down thoughts with a mood tag.',
        builder: (_) => const JournalScreen(),
      ),
      _Tool(
        title: 'Gratitude',
        description: 'List three things you appreciate today.',
        builder: (_) => const GratitudeScreen(),
      ),
      _Tool(
        title: 'Grounding',
        description: '5-4-3-2-1 senses check to calm down.',
        builder: (_) => const GroundingScreen(),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            title: Text(tool.title),
            subtitle: Text(tool.description),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: tool.builder),
              );
            },
          ),
        );
      },
    );
  }
}

class _Tool {
  final String title;
  final String description;
  final WidgetBuilder builder;

  const _Tool({
    required this.title,
    required this.description,
    required this.builder,
  });
}
