// Serviço: separa as regras de armazenamento dos widget da tela
import 'dart:convert';

import 'package:gerenciador_notas/models/nota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotaStorageService {
  // Chave funciona como nome do espaço onde guardamos textos
  static const String chaveNotas = 'lista_notas';
  static const String chaveAntiga = 'nota_inicial';

  //SharedPreferencesAsync lê e grava os valores simples no dispositivo
  // final impedir que _perfs receba  outra instancia depois de criada
  final SharedPreferencesAsync _perfs = SharedPreferencesAsync();

  // Future<List<Nota>> indica que a lista virá no futuro.
  // async permite usar await durante a leitura do dispositivo
  Future<List<Nota>> listarNotas() async {
    // String? permite texto ou null,
    final String? texto = await _perfs.getString(chaveNotas);
    // Se não há lista salva, verificamos a nota da aula 1.
    if (texto == null) {
      final String? antiga = await _perfs.getString(chaveAntiga);
      if (antiga == null || antiga.trim().isEmpty) {
        return []; // retornamos lista vazia, sem notas
      }

      // Tranforma a anotação antiga em uma Nota completa
      final Nota primeira = Nota(
        // Horario em microssegundos gera um identificador simples
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: 'Minha Primeira Nota',
        conteudo: antiga,
      );
      // salva a nota no formato novo e remove a antiga
      await salvarLista([primeira]);
      await _perfs.remove(chaveAntiga);
      return [primeira]; // devolve a nota convertida
    }

    // jsonDecode transforma o texto JSON em estrutura Dart
    // as List<dynamic> informa que esperamos uma lista Dart
    final List<dynamic> dados = jsonDecode(texto) as List<dynamic>;

    // map() percorre cada elemento e transforma em nota.
    // toList() materializa o resultado como uma lista Dart
    return dados.map((item) {
      return Nota.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  // Recebe a lista completa e grava sua versão atualizada
  Future<void> salvarLista(List<Nota> notas) async {
    // Converte cada objeto Nota para Map com toMap()
    final List<Map<String, dynamic>> dados = notas.map((nota) {
      return nota.toMap();
    }).toList();

    // transforma a lista de maps em texto JSON
    final String texto = jsonEncode(dados);
    // await aguarda a conclusão da gravação no dispositivo
    await _perfs.setString(chaveNotas, texto);
  }

  Future<void> adicionarNota(Nota novaNota) async {
    // primiero recuperamos tudo que ja estava salvo
    final List<Nota> notas = await listarNotas();
    notas.add(novaNota);// Insere a nova nota no fim da lista
    await salvarLista(notas); // Grava a lista inteira novamente
  }

  // Recupera a nota, e retorna a String, mesmo quando não existe valor.
  Future<String> buscarNota() async {
    //String significa que o retorno pode ser String ou null.
    final String? nota = await _perfs.getString(chaveNotas);
    // ?? usa o texto vazio caso a nota seja null
    return nota ?? '';
  }

  // Exclui somente o valor que foi salvo na chave da nota
  Future<void> apagarNota() async {
    await _perfs.remove(chaveNotas);
  }
}
