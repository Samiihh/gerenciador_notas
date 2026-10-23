import 'package:flutter/material.dart';
import 'package:gerenciador_notas/provider/notas_provider.dart';
import 'package:gerenciador_notas/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp chama o primeiro widget na tela
  runApp( 
    // cria uma Instancia de notas providers para o app
    // quando nao for mais necessario, o provider a descarta
    ChangeNotifierProvider(
      create: (context) => NotasProvider(),
      // child recebe a aervore que podera acessar esse estado
      child: const GerenciadorNotasApp(),
    )
  
  
  );
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
