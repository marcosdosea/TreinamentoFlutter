import 'package:flutter/material.dart';

// Navigator
void main() {
  runApp(const MaterialApp(
    title: 'Navegação básica',
    home: PrimeiroRoteamento(),
  ));
}

class PrimeiroRoteamento extends StatelessWidget {
  const PrimeiroRoteamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeira Tela'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir nova tela'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SegundoRoteamento()),
            );
          },
        ),
      ),
    );
  }
}

class SegundoRoteamento extends StatelessWidget {
  const SegundoRoteamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Tela'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Voltar'),
        ),
      ),
    );
  }
}