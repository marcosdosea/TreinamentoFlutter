import 'package:flutter/material.dart';

class MyListViewSeparated extends StatelessWidget {
  const MyListViewSeparated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10, // Número total de itens na lista
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Item $index'),
          onTap: () {
            print('Item $index foi tocado.');
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        // Constrói o separador entre os itens da lista
        return Divider();
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Exemplo com o ListView.separated'),
      ),
      body: MyListViewSeparated(),
    ),
  ));
}
