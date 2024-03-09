import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aplicativo Responsivo'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return _buildSmallLayout();
            } else {
              return _buildLargeLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSmallLayout() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Telas pequenas.',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Widget _buildLargeLayout() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40.0),
        child: Text(
          'Telas grandes.',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
