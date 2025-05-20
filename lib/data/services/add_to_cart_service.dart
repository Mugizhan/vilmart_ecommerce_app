import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/add_to_cart/add_to_cart.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getUserId() async => await _storage.read(key: 'uid');

  Future<void> addToCart(CartItem item) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception("User not logged in");

    await _db.collection('users').doc(userId).collection('cart').doc(item.productId).set(item.toJson());
  }

  Future<void> removeFromCart(String productId) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception("User not logged in");

    await _db.collection('users').doc(userId).collection('cart').doc(productId).delete();
  }

  Future<List<CartItem>> getCartItems() async {
    final userId = await _getUserId();
    if (userId == null) throw Exception("User not logged in");

    final snapshot = await _db.collection('users').doc(userId).collection('cart').get();
    return snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
  }

  Future<void> checkout() async {
    final userId = await _getUserId();
    if (userId == null) throw Exception("User not logged in");

    final cartItems = await getCartItems();
    final timestamp = Timestamp.now();

    for (CartItem item in cartItems) {
      await _db.collection('shops').doc(item.sellerId).collection('orders').add({
        'userId': userId,
        'timestamp': timestamp,
        'item': item.toJson(),
        'status': 'pending',
      });
    }

    final cartRef = _db.collection('users').doc(userId).collection('cart');
    final cartSnapshot = await cartRef.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
