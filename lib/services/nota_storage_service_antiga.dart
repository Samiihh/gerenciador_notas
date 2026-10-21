// Serviço: separa as regras de armazenamento dos widget da tela
import 'package:shared_preferences/shared_preferences.dart';

class NotaStorageService {
  // Chave funciona como nome do espaço onde guardamos textos
  static const String chaveNota = 'nota_inicial';

  //SharedPreferencesAsync lê e grava os valores simples no dispositivo
  // final impedir que _perfs receba  outra instancia depois de criada
  final SharedPreferencesAsync _perfs = SharedPreferencesAsync();

  // Recebe o texto e o armazena, mas não devolve um resultado
  Future<void> salvarNotas(String texto) async {
    //setString associa a String a chave escolhida
    await _perfs.setString(chaveNota, texto);
  }

  // Recupera a nota, e retorna a String, mesmo quando não existe valor.
  Future<String> buscarNota() async {
    //String significa que o retorno pode ser String ou null.
    final String? nota = await _perfs.getString(chaveNota);
    // ?? usa o texto vazio caso a nota seja null
    return nota ?? '';
  }

  // Exclui somente o valor que foi salvo na chave da nota
  Future<void> apagarNota() async {
    await _perfs.remove(chaveNota);
  }
}
