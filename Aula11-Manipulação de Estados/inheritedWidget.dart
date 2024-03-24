import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class DadosCompartilhados extends InheritedWidget {
  final String nome;
  final int idade;

  DadosCompartilhados({
    required this.nome,
    required this.idade,
    required Widget child,
  }) : super(child: child);

  static DadosCompartilhados? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DadosCompartilhados>();
  }

  @override
  bool updateShouldNotify(DadosCompartilhados oldWidget) {
    return nome != oldWidget.nome || idade != oldWidget.idade;
  }
}

class PrimeiraTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Primeira Tela')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navega para a segunda tela
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SegundaTela(),
              ),
            );
          },
          child: Text('Ir para Segunda Tela'),
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtém os dados compartilhados do InheritedWidget
    final dados = DadosCompartilhados.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('Segunda Tela')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${dados.nome}'),
            Text('Idade: ${dados.idade}'),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DadosCompartilhados(
      nome: 'João',
      idade: 30,
      child: MaterialApp(
        title: 'InheritedWidget Example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: PrimeiraTela(),
      ),
    );
  }
}
