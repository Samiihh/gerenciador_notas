import 'package:flutter/material.dart';
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
}
