import 'package:priorize/model/categoria_model.dart';
import 'package:priorize/repository/categoria_repository.dart';

class CategoriaService {
  final CategoriaRepository _repository;

  CategoriaService(this._repository);

  bool validarCategoria(String tipo) {
    final tipoLimpo = tipo.trim();

    return tipoLimpo.isNotEmpty &&
        tipoLimpo.length >= 3 &&
        tipoLimpo.length <= 12;
  }

  bool validarNivelPrioridade(String nivel) {
    const nivelPermitido = ['Alta', 'Média', 'Baixa'];
    return nivelPermitido.contains(nivel);
  }

  Future<List<CategoriaModel>> obterCategoria() async {
    return _repository.obterCategoria();
  }

  Future<void> adicionarCategoria(CategoriaModel categoria) async {
    if (!validarCategoria(categoria.tipo)) {
      throw Exception(obterMensagemErroTipo(categoria.tipo));
    }

    final existente = await _repository.obterCategoria();
    final duplicada = existente.any(
      (t) => t.tipo.toLowerCase() == categoria.tipo.toLowerCase(),
    );

    if (duplicada) {
      throw Exception('Já existe uma categoria com esse nome');
    }

    await _repository.adicionarCategoria(categoria);
  }

  String? obterMensagemErroTipo(String tipo) {
    final tipoLimpo = tipo.trim();
    if (tipoLimpo.isEmpty) {
      return 'O nome da categoria não pode ser vazio';
    } else if (tipoLimpo.length < 3) {
      return 'A categoria deve conter no mínimo 3 caracteres';
    } else if (tipoLimpo.length > 20) {
      return 'A categoria deve conter no máximo 20 caracteres';
    }
    return null;
  }

  Future<void> atualizarCategoria(CategoriaModel categoria) async {
    if (!validarCategoria(categoria.tipo)) {
      throw Exception(obterMensagemErroTipo(categoria.tipo));
    }
    await _repository.atualizarCategoria(categoria);
  }

  Future<void> deletarCategoria(String id) async {
    await _repository.deletarCategoria(id);
  }

  List<CategoriaModel> ordenarPorPrioridade(List<CategoriaModel> categorias) {
    const prioridadePeso = {'Alta': 3, 'Média': 2, 'Baixa': 1};
    final lista = List<CategoriaModel>.from(categorias);
    lista.sort((a, b) =>
        prioridadePeso[b.nivelPrioridade]!
            .compareTo(prioridadePeso[a.nivelPrioridade]!));
    return lista;
  }
}