import 'dart:async';

import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  final List<_BreathPhase> _phases = const [
    _BreathPhase('Inhale', 4),
    _BreathPhase('Hold', 7),
    _BreathPhase('Exhale', 8),
  ];

  Timer? _timer;
  int _phaseIndex = 0;
  int _secondsLeft = 4;
  int _cycle = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() {
      _isRunning = true;
      _cycle = 1;
      _phaseIndex = 0;
      _secondsLeft = _phases.first.seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!_isRunning) return;
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft -= 1);
      return;
    }

    if (_phaseIndex < _phases.length - 1) {
      setState(() {
        _phaseIndex += 1;
        _secondsLeft = _phases[_phaseIndex].seconds;
      });
      return;
    }

    // Cycle finished; move to next cycle and restart phases.
    setState(() {
      _cycle += 1;
      _phaseIndex = 0;
      _secondsLeft = _phases[_phaseIndex].seconds;
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _phaseIndex = 0;
      _secondsLeft = _phases.first.seconds;
      _cycle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phase = _phases[_phaseIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Guided 4-7-8 breathing to calm your nervous system.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: _isRunning ? 220 : 180,
                  width: _isRunning ? 220 : 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        phase.label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$_secondsLeft s',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Cycle $_cycle',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _start,
                    child: const Text('Start'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isRunning ? _stop : null,
                    child: const Text('Stop'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BreathPhase {
  final String label;
  final int seconds;
  const _BreathPhase(this.label, this.seconds);
}
