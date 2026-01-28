import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import './detail_screen.dart';
import './cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = productsData.items;

    // --- LÓGICA DE RESPONSIVIDADE ---
    // Pega a largura da tela atual
    double screenWidth = MediaQuery.of(context).size.width;

    // Define quantas colunas usar baseado na largura
    int gridColumns = 2; // Padrão celular
    if (screenWidth > 1200) {
      gridColumns = 5; // Telas muito grandes (PC largo)
    } else if (screenWidth > 800) {
      gridColumns = 4; // PC normal / Tablet deitado
    } else if (screenWidth > 600) {
      gridColumns = 3; // Tablet em pé
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        // APPBAR COM BUSCA E CARRINHO
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF159),
          elevation: 0,
          toolbarHeight: 70,
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)
              ],
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                Provider.of<ProductProvider>(context, listen: false)
                    .searchProducts(value);
              },
              decoration: const InputDecoration(
                hintText: 'Buscar no CoreShop',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // CARRINHO TOPO
          actions: [
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.black87, size: 28),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // --- CORPO DA TELA ---
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFF159), Color(0xFFF5F5F5)],
                      ),
                    ),
                  ),

                  // --- CATEGORIA ---
                  Container(
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          _buildCategoryItem(Icons.apps, 'Todos', 'Todos'),
                          _buildCategoryItem(
                              Icons.bolt, 'Eletrônicos', 'electronics'),
                          _buildCategoryItem(Icons.watch, 'Jóias', 'jewelery'),
                          _buildCategoryItem(
                              Icons.male, "Masculino", "men's clothing"),
                          _buildCategoryItem(
                              Icons.female, "Feminino", "women's clothing"),
                        ],
                      ),
                    ),
                  ),

                  // Grid de Produtos
                  Expanded(
                    child: products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off,
                                    size: 60, color: Colors.grey),
                                const SizedBox(height: 10),
                                Text("Nenhum produto encontrado.",
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: products.length,
                              // AQUI É A MUDANÇA PRINCIPAL
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    gridColumns, // Usa a variável calculada
                                childAspectRatio: 0.68,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (ctx, i) => GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pushNamed(
                                    DetailScreen.routeName,
                                    arguments: products[i].id,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(8)),
                                          child: Hero(
                                            tag: products[i].id,
                                            child: Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl: products[i].imageUrl,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        color:
                                                            Colors.grey[100]),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error,
                                                            color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              products[i].title,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'R\$ ${products[i].price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              '12x sem juros',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF00A650),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Frete grátis',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF00A650),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, String apiValue) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchController.clear();
        Provider.of<ProductProvider>(context, listen: false)
            .filterByCategory(apiValue);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Icon(icon, color: Colors.black54, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
