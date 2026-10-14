import 'package:flutter/material.dart';

void main() {
  runApp(const TodoAppSetState());
}

// Modelo da Tarefa
class Task {
  final String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

class TodoAppSetState extends StatelessWidget {
  const TodoAppSetState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas (SetState)',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TodoHomePageSetState(),
    );
  }
}

class TodoHomePageSetState extends StatefulWidget {
  const TodoHomePageSetState({super.key});

  @override
  State<TodoHomePageSetState> createState() => _TodoHomePageSetStateState();
}

class _TodoHomePageSetStateState extends State<TodoHomePageSetState> {
  final List<Task> _tasks = [
    Task('Estudar Flutter (SetState)', isDone: true),
    Task('Criar Formulário (Provider)'),
    Task('Implementar Menu (BLoC)'),
  ];

  void _addTask(String title) {
    // Altera o estado e notifica a UI para reconstruir o próprio widget (local)
    setState(() {
      _tasks.add(Task(title));
    });
  }

  void _toggleTaskStatus(Task task) {
    // Altera o estado e notifica a UI para reconstruir o próprio widget
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas (SetState)'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone ? Colors.grey : Colors.black,
              ),
            ),
            trailing: Checkbox(
              value: task.isDone,
              onChanged: (bool? newValue) {
                _toggleTaskStatus(task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Nova Tarefa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Título da Tarefa"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addTask(controller.text); 
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}