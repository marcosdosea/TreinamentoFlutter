import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class CounterBloc {
  int _counter = 0;
  final _counterController = StreamController<int>();

  Stream<int> get counterStream => _counterController.stream;

  int get counter => _counter;

  void increment() {
    _counter++;
    _counterController.sink.add(_counter);
  }

  void dispose() {
    _counterController.close();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late CounterBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CounterBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contador com BLoC')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.counterStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Contagem: ${snapshot.data}');
            } else {
              return Text('Contagem: Carregando...');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
