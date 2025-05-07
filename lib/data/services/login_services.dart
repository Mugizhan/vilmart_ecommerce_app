import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../model/login_model/login_model.dart';

class LoginService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> loginUser(LoginModel user) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.phone, // Assuming phone is the email in your case
        password: user.password,
      );

      if (userCredential.user != null) {
        String? storeId = await _getStoreIdFromFirestore(userCredential.user!.uid);
        print('storeId:::${storeId}');
        if (storeId != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userPhone', user.phone);
          await prefs.setString('userPassword', user.password);
          await prefs.setString('storeId', storeId);

          return "Login Successful";
        } else {
          throw Exception("Store ID not found for the user.");
        }
      } else {
        throw Exception("Login Failed: Unable to authenticate user");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception("Login Failed: ${e.message}");
      }
    } on PlatformException catch (e) {
      throw Exception("Platform error: ${e.message}");
    } catch (e) {
      throw Exception("Login Failed: ${e.toString()}");
    }
  }

  // Function to retrieve the storeId from Firestore based on the user's UID
  Future<String?> _getStoreIdFromFirestore(String uid) async {
    try {
      // Assuming you have a 'users' collection where each document has a field 'storeId'
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Retrieve the storeId from the document (adjust field name if necessary)
        String? storeId = userDoc.get('storeId');
        return storeId;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching storeId: ${e.toString()}");
    }
  }
}
