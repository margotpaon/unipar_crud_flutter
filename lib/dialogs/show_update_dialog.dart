import 'package:flutter/material.dart';
import 'package:unipar_crud_flutter/models/product_model.dart';

Future<ProductModel?> showUpdateDialog(
    BuildContext context, ProductModel productModel) {
  final _nameController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _corController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  _nameController.text = productModel.name!;
  _tamanhoController.text = productModel.tamanho!;
  _corController.text = productModel.cor!;
  _precoController.text = productModel.preco!;
  _quantidadeController.text = productModel.quantidade!;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Atualize seus dados aqui'),
                TextField(controller: _nameController),
                TextField(controller: _tamanhoController),
                TextField(controller: _corController),
                TextField(controller: _precoController),
                TextField(controller: _quantidadeController),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final editProduct = ProductModel(
                      id: productModel.id,
                      name: _nameController.text,
                      tamanho: _tamanhoController.text,
                      cor: _corController.text,
                      preco: _precoController.text,
                      quantidade: _quantidadeController.text);
                  Navigator.of(context).pop(editProduct);
                },
                child: const Text('Save'),
              )
            ]);
      }).then((value) {
    if (value is ProductModel) {
      return value;
    } else {
      return 0 as ProductModel;
    }
  });
}
