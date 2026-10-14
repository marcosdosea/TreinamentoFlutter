import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Modelo da Tarefa
class Task {
  final String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

// CLASSE DE ESTADO (Provider)
class TodoListProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task('Estudar Flutter (SetState)', isDone: true),
    Task('Criar Formulário (Provider)'),
    Task('Implementar Menu (BLoC)'),
  ];

  List<Task> get tasks => _tasks;
  
  void addTask(String title) {
    _tasks.add(Task(title));
    notifyListeners(); // Notifica os Consumers de que o estado mudou
  }
  
  void toggleTaskStatus(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }
}

// WIDGET PRINCIPAL
void main() {
  // Define o Provider no topo da árvore de widgets
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoListProvider(),
      child: const TodoAppProvider(),
    ),
  );
}

class TodoAppProvider extends StatelessWidget {
  const TodoAppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Tarefas (Provider)',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TodoHomePageProvider(),
    );
  }
}

class TodoHomePageProvider extends StatelessWidget {
  const TodoHomePageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos .read para obter a instância do Provider para chamar métodos
    final todoProviderActions = context.read<TodoListProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas (Provider - Consumer)'),
      ),
      body: Consumer<TodoListProvider>( 
        builder: (context, todoProvider, child) {
          // O Builder reconstrói APENAS a lista quando o estado muda
          return ListView.builder(
            itemCount: todoProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = todoProvider.tasks[index];
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
                    // Chama a função do Provider para alterar o estado
                    todoProvider.toggleTaskStatus(task);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, todoProviderActions),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TodoListProvider provider) {
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
                  provider.addTask(controller.text);
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