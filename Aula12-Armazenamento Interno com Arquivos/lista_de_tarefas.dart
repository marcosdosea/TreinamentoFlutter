import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TelaListaTarefas(),
    );
  }
}

class TelaListaTarefas extends StatefulWidget {
  @override
  _TelaListaTarefasState createState() => _TelaListaTarefasState();
}

class _TelaListaTarefasState extends State<TelaListaTarefas> {
  List<String> tarefas = [];
  final TextEditingController _controladorTarefa = TextEditingController();
  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }
  
  Future<void> _carregarTarefas() async {
    try {
      final diretorio = await getApplicationDocumentsDirectory();
      final arquivo = File('${diretorio.path}/tarefas.txt');
      if (await arquivo.exists()) {
        final conteudo = await arquivo.readAsString();
        setState(() {
          tarefas = conteudo.split('\n');
        });
      }
    } catch (e) {
      print('Erro ao carregar as tarefas: $e');
    }
  }

  Future<void> _salvarTarefas() async {
    try {
      final diretorio = await getApplicationDocumentsDirectory();
      final arquivo = File('${diretorio.path}/tarefas.txt');
      await arquivo.writeAsString(tarefas.join('\n'));
    } catch (e) {
      print('Erro ao salvar as tarefas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tarefas')),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, indice) {
          return ListTile(title: Text(tarefas[indice]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarTarefa();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _adicionarTarefa() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Tarefa'),
          content: TextField(
            controller: _controladorTarefa,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tarefas.add(_controladorTarefa.text);
                });
                _salvarTarefas();
                _controladorTarefa.clear();
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}