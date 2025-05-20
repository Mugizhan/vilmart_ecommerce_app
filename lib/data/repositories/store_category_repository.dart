import 'package:vilmart/data/services/shop_service.dart';
import '../model/add_store_model/add_store_model.dart';

class ShopCategoryRepository {
  final ShopService _shopService = ShopService();

  Future<List<AddStoreModel>> fetchProducts(String category, String city) async {
    return await _shopService.getShopsByCategoryAndCity(category:category,city: city);
  }
}
