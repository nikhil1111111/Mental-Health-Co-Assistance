import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wellness_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _region = 'IN';

  @override
  Widget build(BuildContext context) {
    final wellness = context.watch<WellnessProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Dark mode'),
          value: wellness.darkMode,
          onChanged: wellness.toggleDarkMode,
        ),
        ListTile(
          title: const Text('Region / Country'),
          subtitle: Text(_region),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () async {
            final selection = await showModalBottomSheet<String>(
              context: context,
              builder: (context) {
                final regions = ['IN', 'US', 'UK', 'Other'];
                return ListView(
                  children: regions
                      .map(
                        (code) => ListTile(
                          title: Text(code),
                          onTap: () => Navigator.pop(context, code),
                        ),
                      )
                      .toList(),
                );
              },
            );
            if (selection != null) {
              setState(() => _region = selection);
            }
          },
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: const ListTile(
            title: Text('Disclaimer'),
            subtitle: Text(
              'This app provides general emotional support via AI. '
              'It is not medical care or a substitute for professional help.',
            ),
          ),
        ),
      ],
    );
  }
}
