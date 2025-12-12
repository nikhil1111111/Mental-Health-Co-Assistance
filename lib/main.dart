import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wellness_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tools_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wellnessProvider = WellnessProvider();
  await wellnessProvider.load();

  runApp(
    ChangeNotifierProvider.value(
      value: wellnessProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wellness = context.watch<WellnessProvider>();
    return MaterialApp(
      title: 'Mental Health Companion',
      debugShowCheckedModeBanner: false,
      theme: kaamWaaleTheme,
      darkTheme: kaamWaaleDarkTheme,
      themeMode: wellness.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: wellness.completedOnboarding
          ? const MainShell()
          : OnboardingScreen(
              onFinished: wellness.setOnboardingComplete,
            ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    ChatScreen(),
    ToolsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Companion'),
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
