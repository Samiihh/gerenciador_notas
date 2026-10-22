import 'package:flutter/material.dart';
import 'package:gerenciador_notas/screens/nota_form_screen.dart';
import 'package:gerenciador_notas/screens/splash_screen.dart';

void main() {
  runApp(const GerenciadorNotasApp());
}

class GerenciadorNotasApp extends StatelessWidget {
  const GerenciadorNotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      // home: NotaFormScreen(),
    );
  }
}
