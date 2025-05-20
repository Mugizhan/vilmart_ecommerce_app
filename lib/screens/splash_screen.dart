import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    try {
      final String? uid = await _storage.read(key: 'uid');
      if (uid != null && uid.isNotEmpty) {
        context.go('/home');
      } else {
        context.go('/');
      }
    } catch (e) {
      print('Error reading from secure storage: $e');
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        width: MediaQuery.of(context).size.width*0.6,
        height: MediaQuery.of(context).size.width*0.6,
        child: Image.asset(
          'assets/images/splash.gif',fit:BoxFit.fill,),
      ),
      nextScreen: const SizedBox.shrink(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
      backgroundColor: Colors.red,
    );
  }
}
