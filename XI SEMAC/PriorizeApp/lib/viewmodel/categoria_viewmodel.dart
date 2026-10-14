import 'package:flutter/foundation.dart';
import 'package:priorize/model/tarefa_model.dart';
import '../model/categoria_model.dart';
import '../service/categoria_service.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service;
  
  List<CategoriaModel> _categorias = [];
  bool _estaCarregando = false;
  String? _mensagemErro;

  List<CategoriaModel> get categorias => List.unmodifiable(_categorias);
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;

  CategoriaViewModel(this._service) {
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _categorias = await _service.obterCategoria();
      // Ordenar por prioridade
      _categorias = _service.ordenarPorPrioridade(_categorias);
    } catch (e) {
      _mensagemErro = 'Erro ao carregar categorias: ${e.toString()}';
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<bool> adicionarCategoria(String tipo, String nivelPrioridade) async {
    // Validar tipo
    final erroTipo = _service.obterMensagemErroTipo(tipo);
    if (erroTipo != null) {
      _mensagemErro = erroTipo;
      notifyListeners();
      return false;
    }

    // Validar prioridade
    if (!_service.validarNivelPrioridade(nivelPrioridade)) {
      _mensagemErro = 'Nível de prioridade inválido';
      notifyListeners();
      return false;
    }

    try {
      final novaCategoria = CategoriaModel(
        id: _gerarIdCategoria(),
        tipo: tipo.trim(),
        nivelPrioridade: nivelPrioridade,
      );

      await _service.adicionarCategoria(novaCategoria);
      
      // Recarregar para atualizar lista
      await carregarCategorias();
      
      _mensagemErro = null;
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarCategoria(
    String id,
    String novoTipo,
    String novaPrioridade,
  ) async {
    // Validar tipo
    final erroTipo = _service.obterMensagemErroTipo(novoTipo);
    if (erroTipo != null) {
      _mensagemErro = erroTipo;
      notifyListeners();
      return false;
    }

    // Validar prioridade
    if (!_service.validarNivelPrioridade(novaPrioridade)) {
      _mensagemErro = 'Nível de prioridade inválido';
      notifyListeners();
      return false;
    }

    try {
      final categoriaAtualizada = CategoriaModel(
        id: id,
        tipo: novoTipo.trim(),
        nivelPrioridade: novaPrioridade,
      );

      await _service.atualizarCategoria(categoriaAtualizada);
      
      // Recarregar para atualizar lista
      await carregarCategorias();
      
      _mensagemErro = null;
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletarCategoria(String id) async {
  try {
    await _service.deletarCategoria(id);
    _categorias.removeWhere((c) => c.id == id);
    _mensagemErro = null;
    notifyListeners();
    return true;
  } catch (e) {
    _mensagemErro = 'Erro ao deletar categoria: ${e.toString()}';
    notifyListeners();
    return false;
  }
}

  CategoriaModel? obterCategoriaPorId(String id) {
    try {
      return _categorias.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }

  String _gerarIdCategoria() {
    return 'cat_${DateTime.now().millisecondsSinceEpoch}';
  }

  int contarTarefasPorCategoria(String categoriaId, List<TarefaModel> tarefas) {
  return tarefas.where((tarefa) => tarefa.idCategoria == categoriaId).length;
}

  
}