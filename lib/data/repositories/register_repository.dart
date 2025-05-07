import '../model/register_model/register_model.dart';
import '../services/register_service.dart';

class RegisterRepository {
  final RegisterService _registerService = RegisterService();

  Future<String> storeData(RegisterModel data) {
    return _registerService.registerUser(data);
  }
}