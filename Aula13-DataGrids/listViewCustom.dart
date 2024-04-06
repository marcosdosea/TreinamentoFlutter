import 'package:flutter/material.dart';

void main() => runApp(const ListViewExampleApp());

class ListViewExampleApp extends StatelessWidget {
  const ListViewExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListViewExample(),
    );
  }
}

class ListViewExample extends StatefulWidget {
  const ListViewExample({Key? key}) : super(key: key);

  @override
  State<ListViewExample> createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<ListViewExample> {
  List<String> items = ['1', '2', '3', '4', '5'];

  // Método para reverter a ordem dos itens da lista
  void _reverseItems() {
    setState(() {
      items = items.reversed
          .toList(); // Atribuímos a lista revertida de volta à variável items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Example'),
      ),
      body: SafeArea(
        child: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return KeepAliveItem(
                data: items[index],
                key: ValueKey<String>(items[index]),
              );
            },
            childCount: items.length,
            findChildIndexCallback: (Key key) {
              final ValueKey<String> valueKey = key as ValueKey<String>;
              final String data = valueKey.value;
              final int index = items.indexOf(data);
              return index;
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _reverseItems,
              child: const Text('Reverse items'),
            ),
          ],
        ),
      ),
    );
  }
}

class KeepAliveItem extends StatefulWidget {
  const KeepAliveItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  State<KeepAliveItem> createState() => _KeepAliveItemState();
}

class _KeepAliveItemState extends State<KeepAliveItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListTile(
      title: Text(widget.data),
    );
  }
}
