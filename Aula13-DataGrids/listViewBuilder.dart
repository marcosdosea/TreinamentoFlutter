import 'package:flutter/material.dart';

class MyListViewBuilder extends StatelessWidget {
  const MyListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, 
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Item $index'), 
          onTap: () {
            print('Item $index foi tocado.');
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Exemplo com o ListView.builder'),
      ),
      body: MyListViewBuilder(),
    ),
  ));
}
