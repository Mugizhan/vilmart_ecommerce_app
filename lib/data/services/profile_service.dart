import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/profile_model/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<CompleteUserData> getUserProfileAndShops() async {
    try {
      final uid = await _secureStorage.read(key: 'uid');
      if (uid == null) throw Exception('UID not found');

      // Fetch user profile
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('User document not found or empty');
      }

      final userProfile = UserProfile.fromJson(userDoc.data()!);

      // Fetch shops by owner
      final shopQuery = await _firestore
          .collection('shops')
          .where('ownerId', isEqualTo: uid)
          .get();

      final userShops = shopQuery.docs.map((doc) {
        final data = doc.data();
        data['shopId'] = doc.id; // Add shopId manually
        return Shop.fromJson(data);
      }).toList();

      return CompleteUserData(userProfile: userProfile, userShops: userShops);
    } catch (e) {
      print('Error loading profile: $e');  // For debugging
      throw Exception('Error loading profile: $e');
    }
  }
}
