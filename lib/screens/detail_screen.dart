import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import './cart_screen.dart'; // Import necessário para navegar pro carrinho

class DetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    // Pega o ID passado pelos argumentos da rota
    final productId = ModalRoute.of(context)?.settings.arguments as String?;

    // Proteção caso o ID venha nulo
    if (productId == null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Erro')),
          body: const Center(child: Text('Produto não encontrado')));
    }

    final loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF159), // Amarelo ML
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do produto (ML coloca o título antes da foto as vezes, ou logo abaixo)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                loadedProduct.title,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),

            // Imagem do Produto
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.white,
              child: CachedNetworkImage(
                imageUrl: loadedProduct.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preço Gigante
                  Text(
                    'R\$ ${loadedProduct.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.w300),
                  ),

                  // Parcelamento
                  const Text(
                    'em 12x sem juros',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF00A650),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Frete grátis',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00A650),
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // Descrição
                  const Text(
                    'O que você precisa saber sobre este produto:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loadedProduct.description,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 16, height: 1.3),
                  ),

                  const SizedBox(height: 30),

                  // Botão de Comprar (Azul ML)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3483FA), // Azul ML
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // --- AQUI ESTAVA O ERRO ---
                        // Agora passamos os 4 argumentos: ID, Preço, Título e IMAGEM
                        Provider.of<CartProvider>(context, listen: false)
                            .addItem(
                          loadedProduct.id,
                          loadedProduct.price,
                          loadedProduct.title,
                          loadedProduct
                              .imageUrl, // <--- Adicionamos a imagem aqui!
                        );

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Adicionado ao carrinho!'),
                            backgroundColor: const Color(0xFF323232),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VER CARRINHO',
                              textColor: const Color(0xFF3483FA),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(CartScreen.routeName);
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Adicionar ao Carrinho',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
