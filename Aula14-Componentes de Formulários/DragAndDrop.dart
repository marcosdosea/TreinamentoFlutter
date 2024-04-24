import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Drag and Drop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DragDropExample(),
    );
  }
}

class DragDropExample extends StatefulWidget {
  @override
  _DragDropExampleState createState() => _DragDropExampleState();
}

class _DragDropExampleState extends State<DragDropExample> {
  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo Drag and Drop'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            direction: Axis.horizontal,
            children: <Widget>[
              Draggable<Color>(
                data: Colors.blue,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: Colors.blue,
                ),
                feedback: Container(
                  color: Colors.blue.withOpacity(0.5),
                  height: 100,
                  width: 100,
                  child: Icon(Icons.touch_app),
                ),
              ),
              Draggable<Color>(
                data: Colors.red,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: Colors.red,
                ),
                feedback: Container(
                  color: Colors.red.withOpacity(0.5),
                  height: 100,
                  width: 100,
                  child: Icon(Icons.touch_app),
                ),
              ),
              Draggable<Color>(
                data: Colors.green,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: Colors.green,
                ),
                feedback: Container(
                  color: Colors.green.withOpacity(0.5),
                  height: 100,
                  width: 100,
                  child: Icon(Icons.touch_app),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          DragTarget<Color>(
            onAccept: (Color color) {
              setState(() {
                caughtColor = color;
              });
            },
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    accepted.isEmpty ? 'Arraste aqui!' : 'Solte para colorir!',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
