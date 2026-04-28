class ProductItemModel {
  final String name;
  final String tag;

  ProductItemModel({required this.name, required this.tag});

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(name: json['name'] ?? '', tag: json['tag'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'tag': tag};
  }
}

class ProductModel {
  final String title;
  final List<ProductItemModel> items;

  ProductModel({required this.title, required this.items});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json['title'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ProductItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'items': items.map((e) => e.toJson()).toList()};
  }
}
