import '../model/add_to_cart/add_to_cart.dart';
import '../services/add_to_cart_service.dart';

class AddToCartRepository {
  final CartService _cartService = CartService();

  Future<void> addToCart(CartItem item) => _cartService.addToCart(item);
  Future<void> removeFromCart(String productId) => _cartService.removeFromCart(productId);
  Future<List<CartItem>> getCartItems() => _cartService.getCartItems();
  Future<void> checkout() => _cartService.checkout();
}
