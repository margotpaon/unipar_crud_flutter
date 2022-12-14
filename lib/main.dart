import 'package:flutter/material.dart';
import 'package:unipar_crud_flutter/models/product_model.dart';
import 'package:unipar_crud_flutter/utils/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductDB _crudStorage;

  @override
  void initState() {
    _crudStorage = ProductDB(dbName: 'db.sqlite');
    _crudStorage.open();
    super.initState();
  }

  @override
  void dispose() {
    _crudStorage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crud Unipar'),
      ),
      body: StreamBuilder(
        stream: _crudStorage.all(),
        builder: (context, snapshot) {
          //print(snapshot);
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data as List<ProductModel>;
              print(products);
              return Column(
                children: [
                  ComposeWidget(
                    onCompose: (name, tamanho, cor, preco, quantidade) async {
                      await _crudStorage.create(
                          name, tamanho, cor, preco, quantidade);
                      print(name);
                      print(tamanho);
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final getProducts = products[index];
                        return ListTile(
                          onTap: () async {
                            final editProduct = await showUpdateDialog(
                              context,
                              getProducts,
                            );
                            if (editProduct != null) {
                              await _crudStorage.update(editProduct);
                            }
                          },
                          title: Text(getProducts.name!),
                          subtitle: Row(
                            children: <Widget>[
                              Flexible(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 30,
                                  direction: Axis.horizontal,
                                  children: [
                                    Text('Tamanho: ${getProducts.tamanho!}'),
                                    Text(' Cor: ${getProducts.cor!}'),
                                    Text(' Preco: ${getProducts.preco!}'),
                                    Text(
                                        ' Quantidade: ${getProducts.quantidade!} '),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: TextButton(
                              onPressed: () async {
                                final shouldDelete =
                                    await showDeleteDialog(context);
                                if (shouldDelete) {
                                  _crudStorage.delete(getProducts);
                                }
                              },
                              child: const Icon(
                                Icons.disabled_by_default_rounded,
                                color: Colors.red,
                              )),
                        );
                      },
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}





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
          decoration: const InputDecoration(hintText: 'Pre??o do produto'),
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

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}
