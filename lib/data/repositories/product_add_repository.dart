import 'package:vilmart/data/services/add_product_service.dart';
import '../model/product_register_model/product_register_model.dart';

class AddProductRepository{

  AddProductService _service=AddProductService();

  Future<String>addProduct(Product data){
    return _service.addProductData(data);
  }
}