import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fundo cinza estilo ML
      appBar: AppBar(
        title: Text(
          'Carrinho (${cart.itemCount})',
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: const Color(0xFFFFF159), // Amarelo ML
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // --- BARRA DE ENDEREÇO ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: const Color(0xFFFFF159),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "Enviar para Ryan - Av Brasil, 123",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // --- LISTA DE PRODUTOS ---
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 20),
                        Text('Seu carrinho está vazio',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      var cartItem = cart.items.values.toList()[i];
                      var productId = cart.items.keys.toList()[i];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1))
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Imagem do Produto
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      cartItem.imageUrl, // Usa a imagem real
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey[200]),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image_not_supported,
                                          color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),

                            // 2. Detalhes
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Título e Lixeira
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cartItem.title,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .removeItem(productId);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, bottom: 8),
                                          child: Icon(Icons.delete_outline,
                                              color: Colors.grey, size: 22),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Controles de Quantidade e Preço
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Seletor de Quantidade
                                      Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            // Botão Menos (-)
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  size: 16, color: Colors.blue),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                  minWidth: 30),
                                              onPressed: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeSingleItem(
                                                        productId);
                                              },
                                            ),
                                            Text(
                                              '${cartItem.quantity} un.',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                            // Botão Mais (+)
                                            IconButton(
                                              icon: const Icon(Icons.add,
                                                  size: 16, color: Colors.blue),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                  minWidth: 30),
                                              onPressed: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .addItem(
                                                  productId,
                                                  cartItem.price,
                                                  cartItem.title,
                                                  cartItem
                                                      .imageUrl, // AGORA ESTAMOS ENVIANDO A FOTO! CARRINHO
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Preço Total do Item
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Frete grátis",
                                    style: TextStyle(
                                        color: Color(0xFF00A650),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // --- RODAPÉ DE RESUMO ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top:
                      BorderSide(color: const Color.fromARGB(255, 189, 1, 1)!)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Produto',
                        style: TextStyle(fontSize: 15, color: Colors.black54)),
                    Text('R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Frete',
                        style: TextStyle(fontSize: 15, color: Colors.black54)),
                    Text('Grátis',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF00A650),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3483FA), // Azul ML
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      cart.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Compra finalizada!')));
                    },
                    child: const Text('Continuar a compra',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
