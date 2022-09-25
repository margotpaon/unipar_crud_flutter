import 'dart:html';

class ProductModel implements Comparable {
  int? id = 0;
  String? name = "";
  String? tamanho = "";
  String? cor = "";
  String? preco = "";
  String? quantidade = "";

  ProductModel({
    this.id,
    this.name,
    this.tamanho,
    this.cor,
    this.preco,
    this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': tamanho,
      'email': cor,
      'image': preco,
      'addressLine1': quantidade,
    };
  }

  @override
  int compareTo(covariant ProductModel other) => other.id!.compareTo(id!);
}
