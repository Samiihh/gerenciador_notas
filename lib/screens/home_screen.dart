import 'package:flutter/material.dart';
import 'package:gerenciador_notas/models/nota.dart';

import 'package:gerenciador_notas/provider/notas_provider.dart';
import 'package:gerenciador_notas/screens/nota_form_screen.dart';

import 'package:provider/provider.dart';

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
  // final _storage = NotaStorageService();

  // lista inicialmente vazia, sera preenchida apos a leitura
  // List<Nota> _notas = [];

  // true indica que os dados ainda estão sendo carregados
  // bool _carregando = true;

  // guarda  somente o filtro visual; não altera notas salvas
  String _pesquisa = '';

  @override
  void initState() {
    super.initState();
    // carregarNotas();  Recuperar o valor ao abrir a home.
    // _carregarNotas(); // Inicia a leitura do armazenamento

    // read acessa o provider sem obervar mudanças
    // Aqui so iniciamos o carregamento uma vez
    // o future é iniciado; e a interface observa o resultado
    context.read<NotasProvider>().carregarNotas();
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

  // Future<void> _carregarNotas() async {
  //   final notasSalvas = await _storage.listarNotas();

  //   if (!mounted) return;

  //   setState(() {
  //     _notas = notasSalvas;
  //     _carregando = false;
  //   });
  // }

  // Future<void> _abrirCadastro() async {
  //   // push abre a tela e espera o valor enviado por pop.
  //   // bool? indica que aceita true, false ou null
  //   final bool? cadastrou = await Navigator.push<bool>(
  //     context,
  //     // builder cria a tela a ser exibida
  //     MaterialPageRoute(builder: (context) => const NotaFormScreen()),
  //   );

  //   if (!mounted) return;
  //   if (cadastrou == true) {
  //     await _carregarNotas(); // Atualiza a lista apos salvar
  //   }
  // }

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

  void _abrirCadastro({Nota? nota}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotaFormScreen(nota: nota)),
    );
  }

  Future<void> _confirmarExclusao(Nota nota) async {
    final bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir nota?'),
        content: Text('Deseja excluir"${nota.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),

            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (!mounted || confirmou != true) return;

    final provider = context.read<NotasProvider>();

    try {
      await provider.excluirNota(nota.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nota Excluida')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao excluir nota.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch observa as alterações e reconstroi esse build quando o
    //provider chamar notifyListeners().
    final estado = context.watch<NotasProvider>();

    //toLowerCase ignora diferencia entre maiusculas/minusculas.
    final termo = _pesquisa.trim().toLowerCase();

    //where cria uma seleção, sem apagar notas provider
    // toList transforma a seleção em uma lista para o listView
    final notasFiltradas = estado.notas.where((nota) {
      return nota.titulo.toLowerCase().contains(termo);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas notas')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar pelo titulo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onChanged: (texto) {
                setState(() => _pesquisa = texto);
              },
            ),
          ),

          Expanded(
            child: estado.carregando
                ? const Center(child: CircularProgressIndicator())
                : estado.erro != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(estado.erro!),
                        TextButton(
                          onPressed: () {
                            context.read<NotasProvider>().carregarNotas();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : notasFiltradas.isEmpty
                ? Center(
                    child: Text(
                      estado.notas.isEmpty
                          ? 'Nenhuma nota cadastrada.'
                          : 'Nenhuma nota encontrada.',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notasFiltradas.length,
                    itemBuilder: (context, index) {
                      final nota = notasFiltradas[index];

                      return Card(
                        child: ListTile(
                          title: Text(nota.titulo),
                          subtitle: Text(nota.conteudo),
                          leading: const Icon(Icons.description_outlined),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _abrirCadastro(nota: nota);
                                },
                                icon: const Icon(Icons.outbond_outlined),
                                tooltip: 'Editar cadastro',
                              ),
                              IconButton(
                                onPressed: () {
                                  _confirmarExclusao(nota);
                                },
                                icon: Icon(Icons.delete_outline),
                                tooltip: 'Excluir nota',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        tooltip: "Cadastrar nota",
        child: const Icon(Icons.add),
      ),
    );
  }
}
