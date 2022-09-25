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
      'tamanho': tamanho,
      'cor': cor,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  @override
  int compareTo(covariant ProductModel other) => other.id!.compareTo(id!);
}
