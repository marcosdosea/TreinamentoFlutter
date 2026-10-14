import 'package:priorize/model/tarefa_model.dart';

class TarefaService {
  bool validarTitulo(String titulo) {
    final tituloLimpo = titulo.trim();
    return tituloLimpo.isNotEmpty &&
        tituloLimpo.length >= 3 &&
        tituloLimpo.length <= 30;
  }

  bool validarDescricao(String descricao) {
    final descricaoLimpa = descricao.trim();
    if (descricaoLimpa.isEmpty) return true; // opcional
    return descricaoLimpa.length >= 3 && descricaoLimpa.length <= 50;
  }

  List<TarefaModel> ordenarTarefasPorDataCriacao(
    List<TarefaModel> tarefas, {
    bool crescente = false,
  }) {
    final lista = List<TarefaModel>.from(tarefas);
    lista.sort((a, b) {
      return crescente
          ? a.dateTime.compareTo(b.dateTime)
          : b.dateTime.compareTo(a.dateTime);
    });
    return lista;
  }

  String formatacaoDataCriacao(DateTime date) {
    final agora = DateTime.now();
    final diferenca = agora.difference(date);

    if (diferenca.inDays == 0) {
      return 'Hoje';
    } else if (diferenca.inDays == 1) {
      return 'Ontem';
    } else if (diferenca.inDays == 7) {
      return 'Semana passada';
    } else if (diferenca.inDays == 30) {
      return 'Mês passado';
    } else if (diferenca.inDays > 35) {
      return 'Há muito tempo';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  double calcularProgresso(List<TarefaModel> tarefas) {
    if (tarefas.isEmpty) {
      return 0.0;
    }
    final concluidas = tarefas.where((t) => t.estaConcluida == true).length;
    return concluidas / tarefas.length;
  }

  int contarTarefaPorCategoria(List<TarefaModel> tarefas, String idCategoria) {
    return tarefas.where((t) => t.idCategoria == idCategoria).length;
  }

  String? obterMensagemErroDescricao(String descricao){
    final trimmed = descricao.trim();
    if (trimmed.isEmpty) return null; // opcional
    if (trimmed.length < 3) return 'Descrição deve conter pelo menos 3 caracteres';
    if (trimmed.length > 500) return 'Descrição deve conter no máximo 500 caracteres';
    return null;
  }

  String? obterMensagemErroTitulo(String titulo) {
    final trimmed = titulo.trim();
    if (trimmed.isEmpty) {
      return 'Título não pode ser vazio';
    } else if (trimmed.length < 3) {
      return 'Título deve conter no mínimo 3 caracteres';
    } 
      return null;
  }

  List<TarefaModel> ordenarTarefasCategoria(
    List<TarefaModel> tarefas,
    String idCategoria,
  ) {
    return tarefas.where((t) => t.idCategoria == idCategoria).toList();
  }

  List<TarefaModel> filtrarTarefaConcluida(List<TarefaModel> tarefas) {
    return tarefas.where((t) => t.estaConcluida).toList();
  }

  List<TarefaModel> filtrarTarefaPendente(List<TarefaModel> tarefas) {
    return tarefas.where((t) => !t.estaConcluida).toList();
  }

  String gerarIdTarefa() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
