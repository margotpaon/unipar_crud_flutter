import 'package:flutter/material.dart';
import 'package:unipar_crud_flutter/compose_widget/compose_widget.dart';
import 'package:unipar_crud_flutter/dialogs/show_delete_dialog.dart';
import 'package:unipar_crud_flutter/dialogs/show_update_dialog.dart';
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
