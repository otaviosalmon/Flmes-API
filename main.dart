import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'firebase_options.dart'; // gerado pelo: flutterfire configure
import 'screens/home_screen.dart';

// main() é async porque precisamos que o Firebase inicialize
// ANTES de qualquer widget ser renderizado.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CineApp());
}

class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark, // tema escuro estilo cinema
      home: const HomeScreen(),
    );
  }
}
