// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';

import 'screens/home_screen.dart';
import 'screens/landing_shop_screen.dart';
import 'screens/admin_product_screen.dart';
import 'screens/admin_product_screen.dart';
import 'providers/admin_product_provider.dart'; // <-- ADD THIS
import 'screens/admin_product_screen.dart';


const String adminEmail = 'admin@gmail.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSI Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LandingController(),
    );
  }
}

/// Decide initial screen based on login & admin
class LandingController extends StatelessWidget {
  const LandingController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.user != null) {
      // Redirect admin to AdminProductScreen
      if (auth.user?.email == adminEmail) {
        return AdminProductScreen();
      } else {
        return HomeScreen();
      }
    } else {
      return LandingShopScreen(); // Guest
    }
  }
}
