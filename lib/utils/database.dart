import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unipar_crud_flutter/models/product_model.dart';

class ProductDB {
  final String dbName;
  Database? _db;
  ProductDB({required this.dbName});
  List<ProductModel> _products = [];
  final _streamController = StreamController<List<ProductModel>>.broadcast();

  // Get all data on database
  Future<List<ProductModel>> _fetchProducts() async {
    final db = _db;
    if (db == null) return [];
    try {
      final read = await db.query('Product',
          distinct: true,
          columns: ['ID', 'NAME', 'TAMANHO', 'COR', 'PRECO', 'QUANTIDADE'],
          orderBy: 'ID');
      final getProducts = read.map((row) => ProductModel.fromRow(row)).toList();
      return getProducts;
    } catch (e) {
      print('Error fetching people =$e');
      return [];
    }
  }

  Future<bool> create(String name, String tamanho, String cor, String preco,
      String quantidade) async {
    final db = _db;
    if (db == null) {
      return false;
    }
    try {
      final id = await db.insert('Product', {
        'NAME': name,
        'TAMANHO': tamanho,
        'COR': cor,
        'PRECO': preco,
        'QUANTIDADE': quantidade
      });
      final products = ProductModel(
          id: id,
          name: name,
          tamanho: tamanho,
          cor: cor,
          preco: preco,
          quantidade: quantidade);
      _products.add(products);
      _streamController.add(_products);
      return true;
    } catch (e) {
      print('Error in creating product =$e');
      return false;
    }
  }

  // Open database
  Future<bool> open() async {
    _db != null ? true : false;

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName';

    try {
      final db = await openDatabase(path);
      _db = db;

      //CREATE TABLE IN DATABASE
      const createTable = '''
          CREATE TABLE IF NOT EXISTS Product(
            ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
            NAME STRING NOT NULL,
            TAMANHO STRING NOT NULL,
            COR STRING NOT NULL,
            PRECO STRING NOT NULL,
            QUANTIDADE STRING NOT NULL
          )
      ''';

      await db.execute(createTable);

      // read all existing Product objects from the db

      _products = await _fetchProducts();
      _streamController.add(_products);
      print("CHEGAMOS AQUI!!!");
      return true;
    } catch (e) {
      print('Error =$e');
      return false;
    }
  }

  // Close database
  Future<bool> close() async {
    final db = _db;
    if (db == null) {
      return false;
    }
    await db.close();
    return true;
  }

  Future<bool> update(ProductModel productModel) async {
    final db = _db;
    if (db == null) {
      return false;
    }
    try {
      final updateCount = await db.update(
        'Product',
        {
          'NAME': productModel.name,
          'TAMANHO': productModel.tamanho,
          'COR': productModel.cor,
          'PRECO': productModel.preco,
          'QUANTIDADE': productModel.quantidade
        },
        where: 'ID=?',
        whereArgs: [productModel.id],
      );
      if (updateCount == 1) {
        _products.removeWhere((other) => other.id == productModel.id);
        _products.add(productModel);
        _streamController.add(_products);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Failed to update product $e');
      return false;
    }
  }

  Future<bool> delete(ProductModel productModel) async {
    final db = _db;
    if (db == null) {
      return false;
    }
    try {
      final deletedCount = await db.delete(
        'Product',
        where: 'ID=?',
        whereArgs: [productModel.id],
      );

      if (deletedCount == 1) {
        _products.remove(productModel);
        _streamController.add(_products);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Deletion failed with error $e');
      return false;
    }
  }

  Stream<List<ProductModel>> all() =>
      _streamController.stream.map((products) => products..sort());
}
