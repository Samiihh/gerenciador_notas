import 'package:flutter/material.dart';
import 'package:gerenciador_notas/models/nota.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';

// ChangeNotifier pertence ao Flutter e permite avisar widgets que observam este objeto quando os dados forem alterados
class NotasProvider extends ChangeNotifier {
  final NotaStorageService _storage = NotaStorageService();

  // Lista privada: outras telas não devem modifica-la diretamente.
  List<Nota> _notas = [];

  bool _carregando = false;

  String? _erro;

  //Getters permite consultar o estado sem expor as variaveis
  //List.unmodifiable impede alterações externas por add/remove.
  List<Nota> get notas => List.unmodifiable(_notas);
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarNotas() async {
    //Mudar o estado ANTES de começar a leitura
    _carregando = true;
    _erro = null;
    // Avisa a Home para exibir o indicador de carregamento.
    notifyListeners();

    try {
      // await esperar o armazenamento responder, sem travar a UI
      _notas = await _storage.listarNotas();
    } catch (e) {
      // Mantemos uma mensagem de erro para tela
      _erro = 'Não foi possivel carregar notas';
    } finally {
      // finally executa tanto no sucesso quanto em caso de erro
      _carregando = false;
      // avisamos que acabou a leitura e a interface pode carregar
      notifyListeners();
    }
  }

  Future<void> adicionarNotas(Nota novaNota) async {
    // Primeiro gravamos no dispositivo, se falhar, a lista visual, não sera alterada, evitamos mostrar algo que não foi salvo
    await _storage.adicionarNota(novaNota);
    // apos de gravar busca a nova lista atualizada
    _notas = await _storage.listarNotas();
    _erro = null;
    // notificamos os widgets que usam o context.watch ou Consumer.
    notifyListeners();
  }

  Future<void> atualizarNota(Nota notaAtualizada) async {
    await _storage.atualizarNota(notaAtualizada); // atualizamos a nota
    _notas = await _storage.listarNotas(); // bucamos a nova lista
    _erro = null;
    notifyListeners(); // atualiza a home sem regarregar a tela;
  }

  Future<void> excluirNota(String id) async {
    await _storage.excluirNota(id);
    _notas = await _storage.listarNotas();
    _erro = null;
    notifyListeners();
  }
}
