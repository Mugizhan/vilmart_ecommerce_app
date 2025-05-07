import 'package:go_router/go_router.dart';
import 'package:vilmart_android/screens/add_product.dart';
import 'package:vilmart_android/screens/add_store.dart';
import 'package:vilmart_android/screens/login_screen.dart';
import 'package:vilmart_android/screens/main_screen.dart';
import 'package:vilmart_android/screens/otp_verify_screen.dart';
import 'package:vilmart_android/screens/registration_screen.dart';

class AppRouter {
      static GoRouter router(bool isLoggedIn) {
            return GoRouter(
                  initialLocation: isLoggedIn ? '/home' : '/', // Conditional initial route
                  routes: [
                        // Login Route
                        GoRoute(
                              name: 'login',
                              path: '/',
                              builder: (context, state) => const LoginScreen(),
                        ),
                        // Registration Route
                        GoRoute(
                              name: 'register',
                              path: '/register',
                              builder: (context, state) => const RegisterScreen(),
                        ),
                        // OTP Route
                        GoRoute(
                              name: 'otp',
                              path: '/otp',
                              builder: (context, state) => OtpVerifyPage(),
                        ),
                        // Home Route
                        GoRoute(
                              name: 'home',
                              path: '/home',
                              builder: (context, state) => const MainScreen(),
                        ),
                        // Add Store Route
                        GoRoute(
                              name: 'addstore',
                              path: '/store',
                              builder: (context, state) => const AddStore(),
                        ),
                        GoRoute(
                              name: 'addproducts',
                              path: '/product',
                              builder: (context, state) => const AddProduct(),
                        ),
                  ],
            );
      }
}
