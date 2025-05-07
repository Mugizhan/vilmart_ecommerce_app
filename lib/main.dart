import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vilmart_android/data/repositories/home_repository.dart';
import 'package:vilmart_android/data/repositories/login_repositories.dart';
import 'package:vilmart_android/data/repositories/register_repository.dart';
import 'package:vilmart_android/router/router_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkIfLoggedIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user != null) {
      // User is already logged in
      return true;
    }

    // Try logging in using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPhone = prefs.getString('userPhone');
    String? userPassword = prefs.getString('userPassword');
    String? storeId = prefs.getString('storeId');

    if (userPhone != null && userPassword != null && storeId != null) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: userPhone,
          password: userPassword,
        );
        return true;
      } on FirebaseAuthException catch (e) {
        debugPrint('Auto-login failed: ${e.message}');
        return false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginRepository>(create: (context) => LoginRepository()),
        RepositoryProvider<RegisterRepository>(create: (context) => RegisterRepository()),
        RepositoryProvider<HomeRepository>(create: (context) => HomeRepository()),
      ],
      child: FutureBuilder<bool>(
        future: _checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          final bool isLoggedIn = snapshot.data ?? false;

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router(isLoggedIn),
          );
        },
      ),
    );
  }
}
