import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleNotesApp());
}

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário de Anotações (Local Dev)',
      theme: ThemeData(
        primarySwatch: Colors.teal, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
        ),
      ),
      home: const NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<String> _notes = [];
  final TextEditingController _noteController = TextEditingController();
  
  static const String _dataDirectory = 'dados_internos';
  static const String _fileName = 'anotacoes_diarias.txt';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  
  // MÉTODOS DE ARQUIVO (CLASSES File e Directory)
  // Obtém a referência ao arquivo dentro do diretório do projeto
  Future<File> _getFile() async {
    // 1. Cria a referência ao diretório (Directory)
    final directory = Directory(_dataDirectory);
    
    // 2. Garante que o diretório exista antes de qualquer operação
    if (!await directory.exists()) {
      await directory.create(recursive: true); // Cria o diretório
    }
    
    // 3. Retorna a referência completa ao arquivo (File)
    return File('${directory.path}/$_fileName'); 
  }

  Future<void> _loadNotes() async {
    try {
      final file = await _getFile();
      if (await file.exists()) { 
        final content = await file.readAsString();
        
        if (content.isNotEmpty) {
           setState(() {
             _notes = content.split('---').where((s) => s.trim().isNotEmpty).toList();
           });
        }
      }
    } catch (e) {
      // Este erro de carregamento será ignorado se for a primeira execução
      print('Erro ao carregar anotações: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final file = await _getFile();
      // Converte a lista em uma única string, usando '---' como separador.
      await file.writeAsString(_notes.join('---'));
    } catch (e) {
      print('Erro ao salvar anotações: $e');
    }
  }
  
  // MÉTODOS DE ESTADO E INTERFACE  
  void _addNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Anotação'),
          content: TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Escreva sua anotação aqui...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.trim().isNotEmpty) {
                  setState(() {
                    _notes.add(_noteController.text.trim()); 
                  });
                  _saveNotes(); 
                  _noteController.clear();
                  Navigator.pop(context); 
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllNotes() async {
    try {
      // 1. Limpa o estado efêmero e notifica a UI
      setState(() {
        _notes.clear(); 
      });

      // 2. Salva o estado vazio no arquivo para persistir a exclusão.
      await _saveNotes(); 

      // 3. Exclui o arquivo fisicamente.
      final file = await _getFile();
      if (await file.exists()) {
         await file.delete(); 
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todas as anotações foram excluídas.')),
      );
    } catch (e) {
      print('Erro ao excluir anotações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário de Anotações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _notes.isNotEmpty ? _deleteAllNotes : null,
            tooltip: 'Excluir Todas',
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma anotação. Use o botão "Editar" para adicionar.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(_notes[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.edit),
      ),
    );
  }
}