import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _checkout() {
    if (CartService.items.isEmpty) return;

    CartService.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Siparişiniz alındı!'),
        backgroundColor: Color(0xFF02C1D3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFEEFAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF124F54),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEEFAFB)),
        title: const Text(
          'Sepetim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEFAFB),
          ),
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: const Color(0xFF124F54).withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sepetiniz boş',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF124F54),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Alışverişe başlamak için kataloğu ziyaret edin',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF124F54).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.store_rounded),
                      label: const Text('Alışverişe Başla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02C1D3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final product = item['product'] as Product;
                      final quantity = item['quantity'] as int;
                      final totalItemPrice = product.price * quantity;

                      return Dismissible(
                        key: Key('${product.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onDismissed: (_) {
                          CartService.removeItem(product.id);
                          setState(() {});
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _navigateToDetail(product),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      color: const Color(0xFFEEFAFB),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            size: 28,
                                            color: Color(0xFF124F54),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF124F54),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF02C1D3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildQuantityButton(
                                      icon: Icons.remove_rounded,
                                      onTap: () {
                                        CartService.decreaseQuantity(product.id);
                                        setState(() {});
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF124F54),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildQuantityButton(
                                      icon: Icons.add_rounded,
                                      onTap: () {
                                        CartService.increaseQuantity(product.id);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF124F54).withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Toplam Tutar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF124F54),
                              ),
                            ),
                            Text(
                              '\$${CartService.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF02C1D3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF02C1D3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF02C1D3).withValues(alpha: 0.4),
                            ),
                            child: const Text(
                              'Sepeti Onayla',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFEEFAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF124F54).withValues(alpha: 0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF124F54),
        ),
      ),
    );
  }
}
