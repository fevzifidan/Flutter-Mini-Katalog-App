import 'package:flutter/material.dart';
import '../components/product_card.dart';
import '../components/search_bar_widget.dart';
import '../components/promo_banner.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../services/local_storage_service.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _allProducts;
  String _searchQuery = '';

  List<Product> get _filteredProducts {
    if (_allProducts == null || _searchQuery.isEmpty) {
      return _allProducts ?? [];
    }
    return _allProducts!
        .where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.fetchProducts();
  }

  void _refreshProducts() {
    setState(() {
      _allProducts = null;
      _productsFuture = ApiService.fetchProducts();
    });
  }

  void _navigateToDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
    setState(() {});
  }

  void _navigateToCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
    setState(() {});
  }

  void _logout() {
    LocalStorageService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEFAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF124F54),
        elevation: 0,
        title: const Text(
          'Mini Katalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEFAFB),
            letterSpacing: 1,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded, color: Color(0xFFEEFAFB)),
                onPressed: _navigateToCart,
              ),
              if (CartService.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF02C1D3),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${CartService.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFEEFAFB)),
            onPressed: _logout,
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF02C1D3),
                strokeWidth: 3,
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: Color(0xFF124F54),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ürünler yüklenemedi',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xFF124F54).withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refreshProducts,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Tekrar Dene'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02C1D3),
                        foregroundColor: const Color(0xFFEEFAFB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data!;
          _allProducts ??= products;

          final displayProducts = _filteredProducts;

          return Column(
            children: [
              SearchBarWidget(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
              const PromoBanner(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _refreshProducts();
                  },
                  child: displayProducts.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 48,
                                      color: const Color(0xFF124F54).withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Aramanızla eşleşen ürün bulunamadı',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color(0xFF124F54).withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: displayProducts.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: displayProducts[index],
                                onTap: () => _navigateToDetail(displayProducts[index]),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}