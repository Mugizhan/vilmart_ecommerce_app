import '../model/register_model/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser(RegisterModel model) async {

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        ...model.toJson(),
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return "Registration successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Firebase Auth error";
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    }
  }
}
