import 'package:flutter/material.dart';
import 'package:gerenciador_notas/models/nota.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';

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

    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha os dois campos')));

      return;
    }

    setState(() => _salvando = true);

    final nota = Nota(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
    );


  }
}
