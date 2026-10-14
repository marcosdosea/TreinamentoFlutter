import 'package:flutter/material.dart';
import 'package:priorize/model/tarefa_model.dart';
import 'package:priorize/repository/tarefas_repository.dart';
import 'package:priorize/service/tarefa_service.dart';
import 'package:priorize/viewmodel/categoria_viewmodel.dart'; 

class TarefaViewModel extends ChangeNotifier {
  final TarefasRepository _repository;
  final TarefaService _service;
  CategoriaViewModel? _categoriaViewModel; 

  List<TarefaModel> _tarefas = [];
  List<TarefaModel> _tarefasFiltradas = [];
  bool _estaCarregando = false;
  String? _mensagemErro;
  
  String? _categoriaIdSelecionada;
  String? _prioridadeSelecionada;

  /// Getters
  List<TarefaModel> get tarefas => List.unmodifiable(
    _tarefasFiltradas.isEmpty && _categoriaIdSelecionada == null && _prioridadeSelecionada == null
        ? _tarefas 
        : _tarefasFiltradas
  );
  
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;
  String? get categoriaIdSelecionada => _categoriaIdSelecionada;
  String? get prioridadeSelecionada => _prioridadeSelecionada;
  int get totalTarefas => _tarefas.length;

  int get tarefasConcluidas => _service.filtrarTarefaConcluida(tarefas).length;
  int get tarefasNaoConcuidas => _service.filtrarTarefaPendente(tarefas).length;
  double get progressoTarefas => _service.calcularProgresso(tarefas).toDouble();

  TarefaViewModel(this._repository, this._service);

  void setCategoriaViewModel(CategoriaViewModel categoriaViewModel) {
    _categoriaViewModel = categoriaViewModel;
  }

  Future<void> carregarTarefas() async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _tarefas = await _repository.obterTarefa();
      _tarefas = _service.ordenarTarefasPorDataCriacao(_tarefas);
      _aplicarFiltros();
    } catch (e) {
      _mensagemErro = 'Erro ao carregar as tarefas';
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<bool> adicionarTarefa({
    required String titulo,
    required String descricao,
    required String idCategoria,
  }) async {
    final erroTitulo = _service.obterMensagemErroTitulo(titulo);
    final erroDescricao = _service.obterMensagemErroDescricao(descricao);

    if (erroTitulo != null) {
      _mensagemErro = erroTitulo;
      notifyListeners();
      return false;
    }

    if (erroDescricao != null) {
      _mensagemErro = erroDescricao;
      notifyListeners();
      return false;
    }

    try {
      final novatarefa = TarefaModel(
        id: _service.gerarIdTarefa(),
        titulo: titulo.trim(),
        descricao: descricao.trim(),
        idCategoria: idCategoria,
        dateTime: DateTime.now(),
        estaConcluida: false,               
      );

      await _repository.adicionarTarefa(novatarefa);
      _tarefas.add(novatarefa);
      _tarefas = _service.ordenarTarefasPorDataCriacao(_tarefas);
      _aplicarFiltros();

      _mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao adicionar nova tarefa';
      notifyListeners();
      return false;
    }
  }

  Future<void> alterarConclusaoTarefa(TarefaModel tarefaModel) async {
    try {
      final tarefaAtualizada = tarefaModel.atualizarAtributos(
        estaConcluida: !tarefaModel.estaConcluida,
      );

      await _repository.atualizarTarefa(tarefaAtualizada);

      final index = _tarefas.indexWhere((t) => t.id == tarefaModel.id);
      if (index != -1) {
        _tarefas[index] = tarefaAtualizada;
        _aplicarFiltros();
        notifyListeners();
      }
    } catch (e) {
      _mensagemErro = 'Erro ao alterar conclusão de tarefa';
      notifyListeners();
    }
  }

  Future<bool> deletarTarefa(String id) async {
    try {
      final tarefaDelete = _tarefas.where((t) => t.id == id);

      if (tarefaDelete.isEmpty) {
        _mensagemErro = 'Tarefa não encontrada';
        return false;
      }

      await _repository.deletarTarefa(id);
      _tarefas.removeWhere((t) => t.id == id);
      _aplicarFiltros();

      _mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao deletar tarefa';
      notifyListeners();
      return false;
    }
  }

  /// Filtrar por categoria
  void obterPorCategoria(String idCategoria) {
    _categoriaIdSelecionada = idCategoria;
    _aplicarFiltros();
    notifyListeners();
  }

  /// Limpar filtro de categoria
  void limparFiltroCategoria() {
    _categoriaIdSelecionada = null;
    _aplicarFiltros();
    notifyListeners();
  }

  /// Filtrar por prioridade
  void filtrarPorPrioridade(String prioridade) {
    _prioridadeSelecionada = prioridade;
    _aplicarFiltros();
    notifyListeners();
  }

  /// Limpar filtro de prioridade
  void limparFiltroPrioridade() {
    _prioridadeSelecionada = null;
    _aplicarFiltros();
    notifyListeners();
  }

  /// 👇 ATUALIZAR ESSE MÉTODO
  void _aplicarFiltros() {
    _tarefasFiltradas = List.from(_tarefas);

    // Filtrar por categoria se houver
    if (_categoriaIdSelecionada != null) {
      _tarefasFiltradas = _tarefasFiltradas
          .where((t) => t.idCategoria == _categoriaIdSelecionada)
          .toList();
    }

    // 👇 FILTRAR POR PRIORIDADE (ATRAVÉS DA CATEGORIA)
    if (_prioridadeSelecionada != null && _categoriaViewModel != null) {
      _tarefasFiltradas = _tarefasFiltradas.where((tarefa) {
        // Buscar a categoria da tarefa
        final categoria = _categoriaViewModel!.obterCategoriaPorId(tarefa.idCategoria);
        // Verificar se a prioridade da categoria corresponde ao filtro
        return categoria?.nivelPrioridade == _prioridadeSelecionada;
      }).toList();
    }
  }

  Future<void> alternarConclusao(TarefaModel tarefa) async {
  try {
    final tarefaAtualizada = tarefa.atualizarAtributos(
      estaConcluida: !tarefa.estaConcluida,
    );

    // Atualizar no banco
    await _repository.atualizarTarefa(tarefaAtualizada);

    // Atualizar na lista em memória
    final index = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      _tarefas[index] = tarefaAtualizada;
      _aplicarFiltros();
      notifyListeners();
    }
  } catch (e) {
    _mensagemErro = 'Erro ao marcar tarefa como concluída';
    notifyListeners();
  }
}

  // Métodos auxiliares
  int contarPendente() {
    return _service.filtrarTarefaPendente(tarefas).length;
  }

  int contarTarefaPorCategoria(String idCategoria) {
    return _service.contarTarefaPorCategoria(_tarefas, idCategoria);
  }

  List<TarefaModel> obterTarefasPendente() {
    return _service.filtrarTarefaPendente(tarefas);
  }

  List<TarefaModel> obterTarefasConcluidas() {
    return _service.filtrarTarefaConcluida(tarefas);
  }

  String formatarData(DateTime data) {
    return _service.formatacaoDataCriacao(data);
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }
}
