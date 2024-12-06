import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      // Configurando rotas nomeadas
      initialRoute: '/', // Define a rota inicial
      routes: {
        '/': (context) => SplashScreen(), // Rota para a SplashScreen
      },
    );
  }
}
