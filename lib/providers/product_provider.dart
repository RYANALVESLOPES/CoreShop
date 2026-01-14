import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import do pacote HTTP
import 'dart:convert'; // Para converter os dados (JSON)
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  // Lista original completa (para quando limpar o filtro)
  List<Product> _allItems = [];

  List<Product> get items {
    return [..._items];
  }

  // --- API ---
  Future<void> fetchProducts() async {
    const url = 'https://fakestoreapi.com/products';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Product> loadedProducts = [];

        for (var prod in data) {
          loadedProducts.add(Product(
            id: prod['id']
                .toString(), // API manda numero, convertemos pra texto
            title: prod['title'],
            description: prod['description'],
            price: (prod['price'] as num).toDouble(),
            imageUrl: prod['image'], // A API usa 'image'
            category: prod['category'], // A API já manda a categoria certa
          ));
        }

        _items = loadedProducts;
        _allItems = loadedProducts; // Guarda uma cópia de segurança
        notifyListeners();
      }
    } catch (error) {
      print("Erro ao buscar produtos: $error");
      throw error;
    }
  }

  // Busca Local (Filtra na lista que já baixamos)
  void searchProducts(String query) {
    if (query.isEmpty) {
      _items = [..._allItems];
    } else {
      _items = _allItems.where((prod) {
        return prod.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Filtro por Categoria
  void filterByCategory(String category) {
    if (category == 'Todos') {
      _items = [..._allItems];
    } else {
      // A FakeStore usa categorias em inglês e minúsculo,
      // então comparamos ignorando maiúsculas/minúsculas/acentos
      _items = _allItems
          .where(
              (prod) => prod.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
