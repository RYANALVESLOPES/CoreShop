import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';
import './providers/cart_provider.dart';
import './screens/home_screen.dart';
import './screens/detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'CoreShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // --- PALETA DE CORES GLOBAL ---
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Fundo cinza claro
          primaryColor: const Color(0xFFFFF159),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFFFF159), // Amarelo
            secondary: const Color(0xFF3483FA), // Azul de Ação
          ),

          // --- ESTILO DOS BOTÕES ---
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3483FA), // Azul padrão
              foregroundColor: Colors.white, // Texto branco
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),

          // --- ESTILO DA APPBAR ---
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFFF159),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF2D3277)),
            titleTextStyle: TextStyle(
              color: Color(0xFF2D3277),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: SplashScreen(),
        routes: {
          '/home': (ctx) => HomeScreen(),
          DetailScreen.routeName: (ctx) => DetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
