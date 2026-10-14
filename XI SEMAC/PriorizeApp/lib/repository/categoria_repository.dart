import 'package:hive/hive.dart';
import '../model/categoria_model.dart';

abstract class CategoriaRepository {
  Future<List<CategoriaModel>> obterCategoria();
  Future<void> adicionarCategoria(CategoriaModel categoria);
  Future<void> deletarCategoria(String id);
  Future<void> atualizarCategoria(CategoriaModel categoria);
  Future<CategoriaModel?> obterCategoriaId(String id);
}

class CategoriaRepositoryImpl implements CategoriaRepository {
  final Box box;

  CategoriaRepositoryImpl(this.box);

  @override
  Future<void> adicionarCategoria(CategoriaModel categoria) async {
    await box.put(categoria.id, categoria.atributosConvertidosEmMap());
  }

  @override
  Future<void> atualizarCategoria(CategoriaModel categoria) async {
    await box.put(categoria.id, categoria.atributosConvertidosEmMap());
  }

  @override
  Future<void> deletarCategoria(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<CategoriaModel>> obterCategoria() async {
    return box.values.map((e) {
      return CategoriaModel.atributosConvertidosEmCategoria(
          Map<String, dynamic>.from(e));
    }).toList();
  }

  @override
  Future<CategoriaModel?> obterCategoriaId(String id) async {
    final map = box.get(id);
    if (map != null) {
      return CategoriaModel.atributosConvertidosEmCategoria(
          Map<String, dynamic>.from(map));
    }
    return null;
  }
}
