import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// StatelessWidget é adequado porque o componente recebe as configuração da tela, sem gerenciar estado próprio.
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label, // a tela deve informar o rotulo
    required this.controller, // a tela fornece o controller
    this.maxLines = 1, // Se omitido, exibe uma linha
  });

  @override
  Widget build(BuildContext context) {
    // TextField desenha um campo editavel na interface
    return TextField(
      controller: controller, // Conecta o compo e o controller
      maxLines: maxLines, // Aplica a quantidade de linhas
      decoration: InputDecoration(
        labelText: label, // Mostra o nome do campo
        border: const OutlineInputBorder(), // Borda Visivel.
      ),
    );
  }
}
