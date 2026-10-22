import 'package:flutter/material.dart';
import 'package:gerenciador_notas/models/nota.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';
import 'package:gerenciador_notas/widget/custom_text_field.dart';

class NotaFormScreen extends StatefulWidget {
  const NotaFormScreen({super.key});

  @override
  State<NotaFormScreen> createState() => _NotasFormScreenState();
}

class _NotasFormScreenState extends State<NotaFormScreen> {
  // Cada um possui seu proprio controller
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  // Serviço responsavel por persistir as notas
  final _storage = NotaStorageService();
  // indica se uma gravação esta em andamento
  bool _salvando = false;

  // nossa função para salvar assincrona sem valor de retorno
  Future<void> _salvar() async {
    // .text obtem o texto; trim() remove os espaços
    final titulo = _tituloController.text.trim();
    final conteudo = _conteudoController.text.trim();

    //verificando se os campos estão vazio e passando uma mensagem em tela para usuario caso seja verdadeiro
    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha os dois campos')));

      return;
    }

    // avisa ao flutter que a interface deve ser atualizada
    setState(() => _salvando = true);

    // Monta o objeto Nota com os valores do formulario
    final nota = Nota(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
    );

    // try executa o salvamento; catch trata possiveis erros.
    try {
      await _storage.adicionarNota(nota); // aguarda gravar
      if (!mounted) return;
      // pop fecha o cadastro e devolve true a Home.
      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;
      // informa se houve problema na gravação dos dados
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Não foi possivel salvar.')));

      // reativa o botão para permitir uma nova tentativa
      setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    // liberando recursos quando a tela é removida
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose(); // Finaliza a limpeza do widget pai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar nota')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(label: 'Titulo', controller: _tituloController),

            const SizedBox(height: 16),

            CustomTextField(
              label: 'Conteudo',
              controller: _conteudoController,
              maxLines: 5,
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: _salvando ? null : _salvar,
              child: Text(_salvando ? 'Salvando...' : 'Salvar nota'),
            ),
          ],
        ),
      ),
    );
  }
}
