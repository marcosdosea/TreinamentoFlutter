import 'package:flutter/material.dart';

void main() {
  runApp(const TodoAppInherited());
}

//MODELO
class Task {
  final String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

//INHERITEDWIDGET (Interface de Acesso aos Dados)
//Este widget define quais dados e métodos serão compartilhados
class TodoInheritedState extends InheritedWidget {
  const TodoInheritedState({
    required this.tasks,
    required this.addTask,
    required this.toggleTaskStatus,
    required super.child,
  });

  final List<Task> tasks;
  final Function(String) addTask;
  final Function(Task) toggleTaskStatus;

  // Método estático para que os widgets filhos possam acessar os dados
  static TodoInheritedState of(BuildContext context) {
    final TodoInheritedState? result =
        context.dependOnInheritedWidgetOfExactType<TodoInheritedState>();
    if (result == null) {
      throw FlutterError('TodoInheritedState não encontrado na árvore!');
    }
    return result;
  }

  // Regra de Reconstrução: A UI só é notificada se a lista de tasks mudar
  @override
  bool updateShouldNotify(TodoInheritedState oldWidget) {
    return tasks != oldWidget.tasks; 
  }
}

// WIDGET QUE MANTÉM O ESTADO (StatefulWidget)
// Este widget gerencia a lista de tarefas e envolve o InheritedWidget
class TodoManager extends StatefulWidget {
  final Widget child;
  const TodoManager({super.key, required this.child});

  @override
  State<TodoManager> createState() => _TodoManagerState();
}

class _TodoManagerState extends State<TodoManager> {
  // Estado Real
  List<Task> _tasks = [
    Task('Estudar Flutter (SetState)', isDone: true),
    Task('Criar Formulário (Provider)'),
  ];

  void _addTask(String title) {
    // CRUCIAL: Cria uma NOVA lista (imutável) para forçar o InheritedWidget a notificar
    setState(() {
      _tasks = List.from(_tasks)..add(Task(title));
    });
  }

  void _toggleTaskStatus(Task task) {
    // CRUCIAL: Força a criação de uma NOVA lista para acionar a notificação
    setState(() {
      task.isDone = !task.isDone;
      _tasks = List.from(_tasks); 
    });
  }

  @override
  Widget build(BuildContext context) {
    // O InheritedWidget repassa o estado (_tasks) e os métodos de alteração
    return TodoInheritedState(
      tasks: _tasks,
      addTask: _addTask,
      toggleTaskStatus: _toggleTaskStatus,
      child: widget.child,
    );
  }
}

// ESTRUTURA DO APP E TELAS
class TodoAppInherited extends StatelessWidget {
  const TodoAppInherited({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoManager(
      child: MaterialApp(
        title: 'Tarefas (InheritedWidget Multi-Tela)',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoState = TodoInheritedState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas (InheritedWidget)'),
      ),
      body: ListView.builder(
        itemCount: todoState.tasks.length,
        itemBuilder: (context, index) {
          final task = todoState.tasks[index];
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
                // Chama a função de alteração
                todoState.toggleTaskStatus(task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final todoState = TodoInheritedState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Título da nova tarefa',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  todoState.addTask(controller.text); 
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}