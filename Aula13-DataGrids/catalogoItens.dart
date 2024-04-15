import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: _generateItems(),
    ),
  );
}

List<ListItem> _generateItems() {
  final List<ListItem> items = [];
  final headingItem = HeadingItem('Cabeçalho');

  items.add(headingItem);

  for (int i = 0; i < 10; i++) {
    items.add(MessageItem('Remetente $i', 'Mensagem $i'));
  }

  return items;
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  const MyApp({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Lista com vários itens';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
              leading: item.buildLeading(context),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Você clicou no ${item.getTappedItem()}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
  Widget? buildLeading(BuildContext context);
  String getTappedItem();
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();

  @override
  Widget? buildLeading(BuildContext context) => Icon(Icons.category);

  @override
  String getTappedItem() => heading;
}

class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);

  @override
  Widget? buildLeading(BuildContext context) => Icon(Icons.message);

  @override
  String getTappedItem() => '$sender';
}
