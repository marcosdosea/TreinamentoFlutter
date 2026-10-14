import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'repository/tarefas_repository.dart';
import 'repository/categoria_repository.dart';
import 'service/tarefa_service.dart';
import 'service/categoria_service.dart';
import 'viewmodel/tarefa_viewmodel.dart';
import 'viewmodel/categoria_viewmodel.dart';
import 'view/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final tarefasBox = await Hive.openBox('tarefas');
  final categoriasBox = await Hive.openBox('categorias');

  final tarefasRepository = TarefasRepositoryImpl(tarefasBox);
  final categoriaRepository = CategoriaRepositoryImpl(categoriasBox);

  final tarefaService = TarefaService();
  final categoriaService = CategoriaService(categoriaRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriaViewModel(categoriaService),
        ),
        ChangeNotifierProxyProvider<CategoriaViewModel, TarefaViewModel>(
          create: (context) {
            final tarefaVM = TarefaViewModel(tarefasRepository, tarefaService);
            tarefaVM.setCategoriaViewModel(context.read<CategoriaViewModel>());
            return tarefaVM;
          },
          update: (context, categoriaVM, tarefaVM) {
            tarefaVM!.setCategoriaViewModel(categoriaVM);
            return tarefaVM;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priorize',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HomeScreen(),
    );
  }
}
