import 'package:flutter/material.dart';
import 'package:priorize/viewmodel/categoria_viewmodel.dart';
import 'package:priorize/viewmodel/tarefa_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../model/tarefa_model.dart';


class TarefaCard extends StatelessWidget {
  final TarefaModel tarefa;

  const TarefaCard({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    final categoriaVM = context.watch<CategoriaViewModel>();
    final categoria = categoriaVM.obterCategoriaPorId(tarefa.idCategoria);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _mostrarDetalhes(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: tarefa.estaConcluida,
                onChanged: (_) {
                  context.read<TarefaViewModel>().alternarConclusao(tarefa);
                },
                shape: const CircleBorder(),
              ),
              
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      tarefa.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: tarefa.estaConcluida
                            ? TextDecoration.lineThrough
                            : null,
                        color: tarefa.estaConcluida
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                    
                    if (tarefa.descricao.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        tarefa.descricao,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: tarefa.estaConcluida
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    // Categoria e Prioridade
                    Row(
                      children: [
                        // Categoria
                        if (categoria != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              categoria.tipo,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        
                        const SizedBox(width: 8),
                        
                        // Prioridade
                        _buildPrioridadeBadge(categoria!.nivelPrioridade),
                        
                        const Spacer(),
                        
                        // Data
                        Text(
                          context.read<TarefaViewModel>().formatarData(tarefa.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Botão deletar
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmarExclusao(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioridadeBadge(String prioridade) {
    Color cor;
    IconData icone;
    
    switch (prioridade.toLowerCase()) {
      case 'alta':
        cor = Colors.red;
        icone = Icons.arrow_upward;
        break;
      case 'media':
      case 'média':
        cor = Colors.orange;
        icone = Icons.remove;
        break;
      case 'baixa':
        cor = Colors.green;
        icone = Icons.arrow_downward;
        break;
      default:
        cor = Colors.grey;
        icone = Icons.flag_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 12, color: cor),
          const SizedBox(width: 4),
          Text(
            prioridade,
            style: TextStyle(
              fontSize: 12,
              color: cor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detalhes da tarefa')),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou == true && context.mounted) {
      final sucesso = await context.read<TarefaViewModel>().deletarTarefa(tarefa.id);
      
      if (sucesso && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tarefa excluída'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}