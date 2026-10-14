class CategoriaModel {
  final String id;
  final String tipo;
  final String nivelPrioridade;

  CategoriaModel({
    required this.id,
    required this.tipo,
    required this.nivelPrioridade,
  });

  Map<String, dynamic> atributosConvertidosEmMap() {
    return {'id': id, 'tipo': tipo, 'nivelPrioridade': nivelPrioridade};
  }

  factory CategoriaModel.atributosConvertidosEmCategoria(
    Map<String, dynamic> map,
  ) {
    return CategoriaModel(
      id: map['id'] as String,
      tipo: map['tipo'] as String,
      nivelPrioridade: map['nivelPrioridade'] as String,
    );
  }

  CategoriaModel atualizarAtributos({String? tipo, String? nivelPrioridade}) {
    return CategoriaModel(
      id: id,
      tipo: tipo ?? this.tipo,
      nivelPrioridade: nivelPrioridade ?? this.nivelPrioridade,
    );
  }
}
