import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paleta de Cores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Paleta de Cores'),
        ),
        body: Scrollbar(
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              final MaterialColor color = Colors.primaries[index % Colors.primaries.length];
              final int shade = (index % 9 + 1) * 100;
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: color[shade],
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Material Color #${index + 1}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${color[shade]}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
