import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controller permite ler o conteudo digitado no TextField
  final TextEditingController _controller = TextEditingController();

  // Instancia do service: a tela não acessa o pacote diretamente
  final NotaStorageService _storage = NotaStorageService();

  // Guarda o texto que a interface mostra abaixo do botão
  String _notaSalva = '';

  @override
  void initState() {
    super.initState();
    carregarNotas(); // Recuperar o valor ao abrir a home.
  }

  // Buscar texto salvo e esperar a leitura e atualiza a interface
  Future<void> carregarNotas() async {
    final String texto = await _storage.buscarNota();

    if (!mounted) return; // se a tela ainda está disponivel.
    setState(() {
      _notaSalva = texto; // Atualiza o texto mostrado em tela
      _controller.text = texto; // preenche o campo com o valor salvo
    });
  }

  // esta função é chamada pelo onPressed do botão salvar
  Future<void> salvarNota() async {
    final String texto = _controller.text.trim();
    if (texto.isEmpty) return;

    await _storage.salvarNotas(texto); // Grava no dispositivo o texto
    if (!mounted) return; // Evita atualizar uma tela descartada

    setState(() {
      _notaSalva = texto; // mostrar a versão recém salva
    });

    // SnackBar informa ao usario que a ação terminou.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nota salva no dispositivo!')));
  }

  // função para apagar a nota
  Future<void> apagarNota() async {
    await _storage.apagarNota(); // remove o valor persistido.
    if (!mounted) return;

    setState(() {
      _notaSalva = ''; // Limpa o texto exibido
      _controller.clear(); // limpa o compo de entrada
    });
  }

  @override
  void dispose() {
    //Libera o controller quando o flutter descartar a tela.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas notas')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Minha primeira anotação',
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 12),

            TextField(
              controller: _controller, //Conecta o campo ao controller
              maxLines: 3, // Maximo de linhas
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva uma anotação...',
              ),
            ),

            SizedBox(height: 12),

            FilledButton(
              onPressed: salvarNota,
              child: const Text('Salvar no dispositivo'),
            ),

            OutlinedButton(
              onPressed: apagarNota,
              child: Text('Apagar nota salva'),
            ),

            const SizedBox(height: 24),

            const Text('Nota recuperada do armazenamento'),
            const SizedBox(height: 8),

            Text(_notaSalva.isEmpty ? 'Nenhuma nota salva.' : _notaSalva),
          ],
        ),
      ),
    );
  }
}
