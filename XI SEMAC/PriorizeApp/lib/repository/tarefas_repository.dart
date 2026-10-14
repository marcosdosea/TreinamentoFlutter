import 'package:hive/hive.dart';
import '../model/tarefa_model.dart';

abstract class TarefasRepository {
  Future<List<TarefaModel>> obterTarefa();
  Future<void> adicionarTarefa(TarefaModel tarefa);
  Future<void> deletarTarefa(String id);
  Future<void> atualizarTarefa(TarefaModel tarefa);
  Future<TarefaModel?> obterTarefaPorId(String id);
}

class TarefasRepositoryImpl implements TarefasRepository {
  final Box box;

  TarefasRepositoryImpl(this.box);

  @override
  Future<void> adicionarTarefa(TarefaModel tarefa) async {
    await box.put(tarefa.id, tarefa.atributosConvertidosEmMap());
  }

  @override
  Future<void> atualizarTarefa(TarefaModel tarefa) async {
    await box.put(tarefa.id, tarefa.atributosConvertidosEmMap());
  }

  @override
  Future<void> deletarTarefa(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<TarefaModel>> obterTarefa() async {
    return box.values.map((e) {
      return TarefaModel.atributosConvertidosEmTarefa(
          Map<String, dynamic>.from(e));
    }).toList();
  }

  @override
  Future<TarefaModel?> obterTarefaPorId(String id) async {
    final map = box.get(id);
    if (map != null) {
      return TarefaModel.atributosConvertidosEmTarefa(
          Map<String, dynamic>.from(map));
    }
    return null;
  }
}
