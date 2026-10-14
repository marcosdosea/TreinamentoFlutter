import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExemploDropdownButton(),
    );
  }
}

class ExemploDropdownButton extends StatefulWidget {
  @override
  _ExemploDropdownButtonState createState() => _ExemploDropdownButtonState();
}

class _ExemploDropdownButtonState extends State<ExemploDropdownButton> {
  String saborPizza = 'Margherita';
  String mensagemSelecao = '';

  void _mostrarSelecao() {
    setState(() {
      mensagemSelecao = 'Você selecionou: $saborPizza';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de DropdownButton'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: saborPizza,
              onChanged: (String? newValue) {
                setState(() {
                  saborPizza = newValue!;
                });
              },
              items: <String>['Margherita', 'Pepperoni', 'Vegetariana', 'Quatro Queijos']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _mostrarSelecao,
              child: Text('Confirmar'),
            ),
            SizedBox(height: 16.0),
            Text(mensagemSelecao),
          ],
        ),
      ),
    );
  }
}
