import 'package:flutter/material.dart';

typedef OnCompose = void Function(
    String name, String tamanho, String cor, String preco, String quantidade);

class ComposeWidget extends StatefulWidget {
  final OnCompose onCompose;
  const ComposeWidget({Key? key, required this.onCompose});

  @override
  State<ComposeWidget> createState() => _ComposeWidgetState();
}

class _ComposeWidgetState extends State<ComposeWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _tamanhoController;
  late final TextEditingController _corController;
  late final TextEditingController _precoController;
  late final TextEditingController _quantidadeController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _tamanhoController = TextEditingController();
    _corController = TextEditingController();
    _precoController = TextEditingController();
    _quantidadeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tamanhoController.dispose();
    _corController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Nome do produto'),
        ),
        TextField(
          controller: _tamanhoController,
          decoration: const InputDecoration(hintText: 'Tamanho do produto'),
        ),
        TextField(
          controller: _corController,
          decoration: const InputDecoration(hintText: 'Cor do produto'),
        ),
        TextField(
          controller: _precoController,
          decoration: const InputDecoration(hintText: 'Preço do produto'),
        ),
        TextField(
          controller: _quantidadeController,
          decoration: const InputDecoration(hintText: 'Quantidade do produto'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text;
            final tamanho = _tamanhoController.text;
            final cor = _corController.text;
            final preco = _precoController.text;
            final quantidade = _quantidadeController.text;
            widget.onCompose(name, tamanho, cor, preco, quantidade);
            _nameController.text = '';
            _tamanhoController.text = '';
            _corController.text = '';
            _precoController.text = '';
            _quantidadeController.text = '';
          },
          child: const Text(
            'Add to List',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ]),
    );
  }
}
