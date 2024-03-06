import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Rotas Nomeadas',
      initialRoute: '/',
      routes: {
        '/': (context) => const PrimeiraTela(),
        '/segunda': (context) => const SegundaTela(),
      },
    ),
  );
}

class PrimeiraTela extends StatelessWidget {
  const PrimeiraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeira Tela'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/segunda');
          },
          child: const Text('Próxima Tela'),
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {
  const SegundaTela({super.key});

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
          child: const Text('Voltar para a primeira tela'),
        ),
      ),
    );
  }
}
