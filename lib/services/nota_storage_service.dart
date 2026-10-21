// Serviço: separa as regras de armazenamento dos widget da tela
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
    }
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
