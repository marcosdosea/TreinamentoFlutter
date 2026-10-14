class TarefaModel {
  final String id;
  final String titulo;
  final String descricao;
  final String idCategoria;
  final bool estaConcluida;
  final DateTime dateTime;

  TarefaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.idCategoria,
    required this.estaConcluida,
    required this.dateTime,
  });

  //converte em Map para salvar no banco
  Map<String, dynamic> atributosConvertidosEmMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'idCategoria': idCategoria,
      'estaConcluida': estaConcluida ? 1 : 0, 
      'dateTime': dateTime.toIso8601String(),
    };
  }
  factory TarefaModel.atributosConvertidosEmTarefa(Map<String, dynamic> map) {
    return TarefaModel(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'] ?? '',
      idCategoria: map['idCategoria'],
      estaConcluida: map['estaConcluida'] == 1,
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
  TarefaModel atualizarAtributos({
    String? id,
    String? titulo,
    String? descricao,
    String? idCategoria,
    bool? estaConcluida,
    DateTime? dateTime,
    String? prioridade,
  }) {
    return TarefaModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      idCategoria: idCategoria ?? this.idCategoria,
      estaConcluida: estaConcluida ?? this.estaConcluida,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
