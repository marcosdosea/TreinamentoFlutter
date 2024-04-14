import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de RadioButton',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExemploRadioButton(),
    );
  }
}

class ExemploRadioButton extends StatefulWidget {
  @override
  _ExemploRadioButtonState createState() => _ExemploRadioButtonState();
}

class _ExemploRadioButtonState extends State<ExemploRadioButton> {
  int opcaoEntrega = 1;
  String textoEntrega = '';

  void _mostrarEntregaSelecionada() {
    switch (opcaoEntrega) {
      case 1:
        textoEntrega = 'Entrega Padrão selecionada.';
        break;
      case 2:
        textoEntrega = 'Entrega Expressa selecionada.';
        break;
      case 3:
        textoEntrega = 'Entrega Econômica selecionada.';
        break;
      case 4:
        textoEntrega = 'Retirada no Local selecionada.';
        break;
      default:
        textoEntrega = 'Nenhuma opção selecionada.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(textoEntrega),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de Radio Button'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Entrega Padrão'),
            leading: Radio<int>(
              value: 1,
              groupValue: opcaoEntrega,
              onChanged: (int? newValue) {
                setState(() {
                  opcaoEntrega = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Entrega Expressa'),
            leading: Radio<int>(
              value: 2,
              groupValue: opcaoEntrega,
              onChanged: (int? newValue) {
                setState(() {
                  opcaoEntrega = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Entrega Econômica'),
            leading: Radio<int>(
              value: 3,
              groupValue: opcaoEntrega,
              onChanged: (int? newValue) {
                setState(() {
                  opcaoEntrega = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Retirada no Local'),
            leading: Radio<int>(
              value: 4,
              groupValue: opcaoEntrega,
              onChanged: (int? newValue) {
                setState(() {
                  opcaoEntrega = newValue!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _mostrarEntregaSelecionada,
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
