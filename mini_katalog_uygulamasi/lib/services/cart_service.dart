import '../models/product_model.dart';

class CartService {
  static final List<Map<String, dynamic>> _items = [];

  static List<Map<String, dynamic>> get items => List.unmodifiable(_items);
  static int get totalItems => _items.fold(0, (sum, item) => sum + (item['quantity'] as int));
  static double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + ((item['product'] as Product).price * (item['quantity'] as int)));

  static void addItem(Product product) {
    final index = _items.indexWhere((item) => (item['product'] as Product).id == product.id);
    if (index >= 0) {
      _items[index]['quantity'] = (_items[index]['quantity'] as int) + 1;
    } else {
      _items.add({'product': product, 'quantity': 1});
    }
  }

  static void increaseQuantity(int productId) {
    final index = _items.indexWhere((item) => (item['product'] as Product).id == productId);
    if (index >= 0) {
      _items[index]['quantity'] = (_items[index]['quantity'] as int) + 1;
    }
  }

  static void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => (item['product'] as Product).id == productId);
    if (index >= 0) {
      final currentQty = _items[index]['quantity'] as int;
      if (currentQty <= 1) {
        _items.removeAt(index);
      } else {
        _items[index]['quantity'] = currentQty - 1;
      }
    }
  }

  static void removeItem(int productId) {
    _items.removeWhere((item) => (item['product'] as Product).id == productId);
  }

  static void clear() {
    _items.clear();
  }
}
