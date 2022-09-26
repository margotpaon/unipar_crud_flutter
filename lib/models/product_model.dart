class ProductModel implements Comparable {
  int? id = 0;
  String? name = "";
  String? tamanho = "";
  String? cor = "";
  String? preco = "";
  String? quantidade = "";

  ProductModel({
    required this.id,
    required this.name,
    required this.tamanho,
    required this.cor,
    required this.preco,
    required this.quantidade,
  });

  ProductModel.fromRow(Map<String, Object?> row)
      : id = row['ID'] as int,
        name = row['NAME'] as String,
        tamanho = row['TAMANHO'] as String,
        cor = row['COR'] as String,
        preco = row['PRECO'] as String,
        quantidade = row['QUANTIDADE'] as String;

  @override
  int compareTo(covariant ProductModel other) => other.id!.compareTo(id!);

  @override
  bool operator ==(covariant ProductModel other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Product, id=$id, name:$name, tamanho:$tamanho, cor:$cor, preco:$preco, quantidade:$quantidade';
}
