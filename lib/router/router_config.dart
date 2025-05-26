import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vilmart/screens/category/category_screen.dart';
import 'package:vilmart/screens/splash_screen.dart';
import '../screens/add_product.dart';
import '../screens/add_store.dart';
import '../screens/category/product_detail_page.dart';
import '../screens/category/shop_product.dart';
import '../screens/generate_qr.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/registration_screen.dart';

Future<GoRouter> createRouter() async {
      final storage = FlutterSecureStorage();
      final uid = await storage.read(key: "uid");
      return GoRouter(
            initialLocation: '/splash',
            routes: [
                  GoRoute(
                        path: '/splash',
                        builder: (context, state) => const SplashScreen(),
                  ),
                  GoRoute(
                        name: 'login',
                        path: '/',
                        builder: (context, state) => const LoginScreen(),
                  ),
                  GoRoute(
                        name: 'register',
                        path: '/register',
                        builder: (context, state) => const RegisterScreen(),
                  ),
                  GoRoute(
                        name: 'home',
                        path: '/home',
                        builder: (context, state) => const MainScreen(),
                  ),
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
                  GoRoute(
                        name: 'category',
                        path: '/category/:name/:location',
                        builder: (context, state) {
                              final category = Uri.decodeComponent(state.pathParameters['name']!);
                              final location = state.pathParameters['location']!;
                              return CataegoryScreen(category: category, location: location);
                        },
                  ),
                  GoRoute(
                        name: 'product',
                        path: '/product/:shopId',
                        builder: (context,state){
                              final shopId=state.pathParameters['shopId'];
                              return ShopProduct(shopId: shopId!);
                        }
                  ),
                  GoRoute(
                        name: 'qr',
                        path: '/qr',
                        builder: (context, state) => QRGeneratorScreen(), // NOT QRViewScreen
                  ),

            ],
      );
}
