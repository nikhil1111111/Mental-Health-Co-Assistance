import 'package:flutter/material.dart';

class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  late List<_GroundingStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _buildSteps();
  }

  List<_GroundingStep> _buildSteps() => [
        _GroundingStep('5 things you can see', 'Look around and name five objects or colors.'),
        _GroundingStep('4 things you can feel', 'Notice textures: your clothing, chair, floor, or air.'),
        _GroundingStep('3 things you can hear', 'Name distant sounds, hums, birds, or your breath.'),
        _GroundingStep('2 things you can smell', 'Coffee, soap, fresh air, your sleeve.'),
        _GroundingStep('1 thing you can taste', 'Sip water, chew gum, or notice lingering taste.'),
      ];

  void _reset() {
    setState(() {
      _steps = _buildSteps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-4-3-2-1 Grounding'),
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          final step = _steps[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: CheckboxListTile(
              value: step.completed,
              onChanged: (value) => setState(() => step.completed = value ?? false),
              title: Text(step.title),
              subtitle: Text(step.detail),
            ),
          );
        },
      ),
    );
  }
}

class _GroundingStep {
  final String title;
  final String detail;
  bool completed;

  _GroundingStep(this.title, this.detail, {this.completed = false});
}
