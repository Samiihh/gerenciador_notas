import 'package:flutter/material.dart';
import 'package:gerenciador_notas/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // initState() roda uma vez , quando o está é criado
    super.initState(); // Mantém a inicialização da classe pai.
    abrirHome(); // Inicia a espera da troca de tela.
  }

  // Future<void>: operação assincrona que não retorna valor
  Future<void> abrirHome() async {
    // afuardar 2 segundos sem travar a interface.
    await Future.delayed(const Duration(seconds: 2));

    // mounted é false se esta tela já foi removida da arvore
    // não podemos usar o context para navegar depois disso
    if (!mounted) return;

    // pushReplacement troca a Splash pela home na pilha de rotas.
    // Assim, o botão voltar não reabre a tela de apresentação
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ocupa o minino necesário
          children: [
            Icon(Icons.edit_note, size: 78, color: Colors.indigo),
            SizedBox(height: 14),
            Text(
              'Gerenciador de Notas',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
