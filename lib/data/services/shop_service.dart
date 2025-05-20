import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/add_store_model/add_store_model.dart';

class ShopService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<String> categoryTitles = [
    'resturant',
    'groceries',
    'electronics & gadgets',
    'fashion & apparel',
    'home & furniture',
    'health & beauty',
    'books & stationery',
    'sports & outdoors',
  ];

  Future<List<AddStoreModel>> getShopsByCategoryAndCity({
    required String category,
    required String city,
  }) async {
    try {
      final querySnapshot = await _db
          .collection('shops')
          .where('category', isEqualTo:categoryTitles[int.parse(category)].toLowerCase())
          .where('address.city', isEqualTo: city.toLowerCase())
          .get();

      print('Categories: ${categoryTitles[int.parse(category)]}');
      print('Cities: ${city}');
      if (querySnapshot.docs.isEmpty) {
        throw Exception("No shop found for category: $category and city: $city");
      }

      final List<AddStoreModel> shops = querySnapshot.docs
          .map((doc) => AddStoreModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();


      for (var shop in shops) {
        print('ShopId: ${shop.shopId}');
        print('Shop Name: ${shop.shopName}');
        print('Category: ${shop.category}');
        print('Owner: ${shop.ownerName}');
        print('City: ${shop.address.city}');
        print('----------------------');
      }
      return shops;
    } catch (e) {
      throw Exception("Failed to fetch shops: $e");
    }
  }
}
