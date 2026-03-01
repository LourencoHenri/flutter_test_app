import 'package:flutter/foundation.dart';
import '../../features/home/domain/models/product.dart';

class ProductsState extends ChangeNotifier {
  // Singleton pattern for simplicity in this project (no DI container)
  static final ProductsState _instance = ProductsState._internal();
  factory ProductsState() => _instance;
  ProductsState._internal();

  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Exemplo de Produto',
      materials: [],
      labor: Labor(hours: 0, hourlyRate: 0),
      operationalCosts: [],
      finalPrice: 89.90,
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
