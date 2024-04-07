import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Checkbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckboxExample(),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de Checkbox'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              value: termsAccepted,
              onChanged: (bool? newValue) {
                setState(() {
                  termsAccepted = newValue!;
                  if (termsAccepted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Você aceitou os termos e condições.'),
                      ),
                    );
                  }
                });
              },
            ),
            Text('Aceito os termos e condições'),
          ],
        ),
      ),
    );
  }
}
