import '../services/profile_service.dart';
import '../model/profile_model/profile_model.dart';

class ProfileRepository {
  final ProfileService _profileService;

  ProfileRepository(this._profileService);

  Future<CompleteUserData> fetchUserProfileAndShops() {
    return _profileService.getUserProfileAndShops();
  }
}
