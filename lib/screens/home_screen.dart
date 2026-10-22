import 'package:flutter/material.dart';
import 'package:gerenciador_notas/models/nota.dart';
import 'package:gerenciador_notas/screens/nota_form_screen.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controller permite ler o conteudo digitado no TextField
  // final TextEditingController _controller = TextEditingController();

  // Instancia do service: a tela não acessa o pacote diretamente
  // final NotaStorageService _storage = NotaStorageService();

  // Guarda o texto que a interface mostra abaixo do botão
  // String _notaSalva = '';

  // Serviços que busca os registros
  final _storage = NotaStorageService();

  // lista inicialmente vazia, sera preenchida apos a leitura
  List<Nota> _notas = [];

  // true indica que os dados ainda estão sendo carregados
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    // carregarNotas();  Recuperar o valor ao abrir a home.
    _carregarNotas(); // Inicia a leitura do armazenamento
  }

  // Buscar texto salvo e esperar a leitura e atualiza a interface
  // Future<void> carregarNotas() async {
  //   final String texto = await _storage.buscarNota();

  //   if (!mounted) return; // se a tela ainda está disponivel.
  //   setState(() {
  //     _notaSalva = texto; // Atualiza o texto mostrado em tela
  //     _controller.text = texto; // preenche o campo com o valor salvo
  //   });
  // }

  Future<void> _carregarNotas() async {
    final notasSalvas = await _storage.listarNotas();

    if (!mounted) return;

    setState(() {
      _notas = notasSalvas;
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro() async {
    // push abre a tela e espera o valor enviado por pop.
    // bool? indica que aceita true, false ou null
    final bool? cadastrou = await Navigator.push<bool>(
      context,
      // builder cria a tela a ser exibida
      MaterialPageRoute(builder: (context) => const NotaFormScreen()),
    );

    if (!mounted) return;
    if (cadastrou == true) {
      await _carregarNotas(); // Atualiza a lista apos salvar
    }
  }

  // // esta função é chamada pelo onPressed do botão salvar
  // Future<void> salvarNota() async {
  //   final String texto = _controller.text.trim();
  //   if (texto.isEmpty) return;

  //   await _storage.salvarNotas(texto); // Grava no dispositivo o texto
  //   if (!mounted) return; // Evita atualizar uma tela descartada

  //   setState(() {
  //     _notaSalva = texto; // mostrar a versão recém salva
  //   });

  //   // SnackBar informa ao usario que a ação terminou.
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text('Nota salva no dispositivo!')));
  // }

  // // função para apagar a nota
  // Future<void> apagarNota() async {
  //   await _storage.apagarNota(); // remove o valor persistido.
  //   if (!mounted) return;

  //   setState(() {
  //     _notaSalva = ''; // Limpa o texto exibido
  //     _controller.clear(); // limpa o compo de entrada
  //   });
  // }

  // @override
  // void dispose() {
  //   //Libera o controller quando o flutter descartar a tela.
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas notas')),

      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _notas.isEmpty
          ? const Center(child: Text('Nenhuma nota Cadastrada'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];

                return Card(
                  child: ListTile(
                    title: Text(nota.titulo),
                    subtitle: Text(nota.conteudo),
                    leading: const Icon(Icons.description_outlined),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        tooltip: "Cadastrar nota",
        child: const Icon(Icons.add),
      ),
    );
  }
}
