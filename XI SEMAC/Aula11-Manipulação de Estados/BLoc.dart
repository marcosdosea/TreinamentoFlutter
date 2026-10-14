import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const TodoAppBloc());
}

// Modelo da Tarefa
class Task {
  final String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

// CLASSE BLoC
class TodoListBloc {
  final List<Task> _tasks = [
    Task('Estudar Flutter (SetState)', isDone: true),
    Task('Criar Formulário (Provider)'),
    Task('Implementar Menu (BLoC)'),
  ];

  // O StreamController armazena e emite a lista de tarefas atualizada.
  final _tasksController = StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get tasksStream => _tasksController.stream;

  TodoListBloc() {
    _tasksController.sink.add(_tasks);
  }

  // EVENTO: Adicionar uma nova tarefa
  void addTask(String title) {
    _tasks.add(Task(title));
    // Envia a nova lista de tarefas para o Stream
    _tasksController.sink.add(_tasks); 
  }

  // EVENTO: Mudar o status da tarefa
  void toggleTaskStatus(Task task) {
    task.isDone = !task.isDone;
    // Envia a lista de tarefas atualizada para o Stream
    _tasksController.sink.add(_tasks);
  }

  void dispose() {
    _tasksController.close();
  }
}

// WIDGETS
class TodoAppBloc extends StatelessWidget {
  const TodoAppBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas (BLoC)',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TodoHomePageBloc(),
    );
  }
}

// Usamos um StatefulWidget apenas para criar e descartar o BLoC
class TodoHomePageBloc extends StatefulWidget {
  @override
  _TodoHomePageBlocState createState() => _TodoHomePageBlocState();
}

class _TodoHomePageBlocState extends State<TodoHomePageBloc> {
  late TodoListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = TodoListBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas (BLoC)'),
      ),
      body: StreamBuilder<List<Task>>(
        stream: bloc.tasksStream, 
        builder: (context, snapshot) {
          // Exibe um loading ou erro se necessário
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa adicionada.'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
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
                    // Dispara o Evento (chama a função do BLoC)
                    bloc.toggleTaskStatus(task);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, bloc),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TodoListBloc bloc) {
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
                  bloc.addTask(controller.text); // Dispara o Evento
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