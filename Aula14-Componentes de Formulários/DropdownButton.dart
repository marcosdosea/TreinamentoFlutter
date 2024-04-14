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
  String saborPizza = 'Margherita'; // Inicialmente, o sabor da pizza é 'Margherita'
  String mensagemSelecao = ''; // A mensagem que será exibida após a seleção

  void _mostrarSelecao() {
    setState(() {
      mensagemSelecao = 'Você selecionou: $saborPizza'; // Atualiza a mensagem com o sabor escolhido
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
              value: saborPizza, // Valor atual do DropdownButton
              onChanged: (String? newValue) {
                setState(() {
                  saborPizza = newValue!; // Atualiza o sabor da pizza com a opção selecionada
                });
              },
              items: <String>['Margherita', 'Pepperoni', 'Vegetariana', 'Quatro Queijos']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Exibe o texto da opção no menu suspenso
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _mostrarSelecao, // Quando o botão é pressionado, chama a função _mostrarSelecao
              child: Text('Confirmar'),
            ),
            SizedBox(height: 16.0),
            Text(mensagemSelecao), // Exibe a mensagem de seleção
          ],
        ),
      ),
    );
  }
}
