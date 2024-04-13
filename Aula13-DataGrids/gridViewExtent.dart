import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    const title = 'Listas em Grade';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.extent(
          // Cria uma grade onde cada item tem uma largura máxima especificada.
          maxCrossAxisExtent: 100,
          // Gera 100 widgets que exibam seu índice na lista.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }),
        ),
      ),
    );
  }
}
