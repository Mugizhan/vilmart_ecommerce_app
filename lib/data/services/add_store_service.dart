import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/add_store_model/add_store_model.dart';

class AddStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addStore(AddStoreModel data) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in.");

    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getString('storeId');
    print('storeId:::${storeId}');
    if (storeId == null) throw Exception("Store ID is not found.");

    try {
      final docRef = _firestore.collection('users').doc(storeId);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) throw Exception("Store with ID: $storeId does not exist.");

      await docRef.update(data.toJson());
      return "Shop updated successfully with ID: $storeId";
    } catch (e) {
      throw Exception("Error updating shop: ${e.toString()}");
    }
  }
}
