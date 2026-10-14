import 'package:flutter/material.dart';
import 'package:priorize/viewmodel/categoria_viewmodel.dart';
import 'package:priorize/viewmodel/tarefa_viewmodel.dart';
import 'package:provider/provider.dart';

class GerenciarCategoriasSheet extends StatelessWidget {
  const GerenciarCategoriasSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gerenciar Categorias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _mostrarAdicionarCategoria(context),
                    tooltip: 'Adicionar categoria',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Lista de categorias
          Flexible(
            child: Consumer2<CategoriaViewModel, TarefaViewModel>(
              builder: (context, categoriaVM, tarefaVM, _) {
                if (categoriaVM.categorias.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhuma categoria',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _mostrarAdicionarCategoria(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Criar primeira categoria'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: categoriaVM.categorias.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final categoria = categoriaVM.categorias[index];
                    final numTarefas = tarefaVM.contarTarefaPorCategoria(
                      categoria.id,
                    );

                    return ListTile(
                      leading: _buildPrioridadeIcon(categoria.nivelPrioridade),
                      title: Text(
                        categoria.tipo,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$numTarefas tarefa${numTarefas != 1 ? "s" : ""}'),
                          _buildPrioridadeBadge(categoria.nivelPrioridade),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _mostrarEditarCategoria(
                              context,
                              categoria,
                            ),
                            tooltip: 'Editar',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarExclusaoCategoria(
                              context,
                              categoria.id,
                              numTarefas,
                            ),
                            tooltip: 'Excluir',
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioridadeIcon(String prioridade) {
    Color cor;
    IconData icone;

    switch (prioridade) {
      case 'Alta':
        cor = Colors.red;
        icone = Icons.arrow_upward;
        break;
      case 'Média':
        cor = Colors.orange;
        icone = Icons.remove;
        break;
      case 'Baixa':
        cor = Colors.green;
        icone = Icons.arrow_downward;
        break;
      default:
        cor = Colors.grey;
        icone = Icons.category;
    }

    return CircleAvatar(
      backgroundColor: cor.withValues(alpha:0.1),
      child: Icon(icone, color: cor),
    );
  }

  Widget _buildPrioridadeBadge(String prioridade) {
    Color cor;

    switch (prioridade) {
      case 'Alta':
        cor = Colors.red;
        break;
      case 'Média':
        cor = Colors.orange;
        break;
      case 'Baixa':
        cor = Colors.green;
        break;
      default:
        cor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Prioridade: $prioridade',
        style: TextStyle(
          fontSize: 12,
          color: cor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _mostrarAdicionarCategoria(BuildContext context) {
    final controllerTipo = TextEditingController();
    String prioridadeSelecionada = 'Média';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nova Categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controllerTipo,
                  decoration: const InputDecoration(
                    labelText: 'Nome da categoria',
                    hintText: 'Ex: Trabalho',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nível de prioridade',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPrioridadeChip(
                      'Alta',
                      Colors.red,
                      Icons.arrow_upward,
                      prioridadeSelecionada == 'Alta',
                      () => setState(() => prioridadeSelecionada = 'Alta'),
                    ),
                    const SizedBox(width: 8),
                    _buildPrioridadeChip(
                      'Média',
                      Colors.orange,
                      Icons.remove,
                      prioridadeSelecionada == 'Média',
                      () => setState(() => prioridadeSelecionada = 'Média'),
                    ),
                    const SizedBox(width: 8),
                    _buildPrioridadeChip(
                      'Baixa',
                      Colors.green,
                      Icons.arrow_downward,
                      prioridadeSelecionada == 'Baixa',
                      () => setState(() => prioridadeSelecionada = 'Baixa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final tipo = controllerTipo.text.trim();

                final sucesso = await context
                    .read<CategoriaViewModel>()
                    .adicionarCategoria(tipo, prioridadeSelecionada);

                if (sucesso && dialogContext.mounted) {
                  Navigator.pop(dialogContext);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Categoria criada!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                   if (!context.mounted) return;
                  final viewModel = context.read<CategoriaViewModel>();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.mensagemErro ?? 'Erro'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    viewModel.limparErro();
                  }
                }
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarEditarCategoria(BuildContext context, dynamic categoria) {
    final controllerTipo = TextEditingController(text: categoria.tipo);
    String prioridadeSelecionada = categoria.nivelPrioridade;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controllerTipo,
                  decoration: const InputDecoration(
                    labelText: 'Nome da categoria',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nível de prioridade',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPrioridadeChip(
                      'Alta',
                      Colors.red,
                      Icons.arrow_upward,
                      prioridadeSelecionada == 'Alta',
                      () => setState(() => prioridadeSelecionada = 'Alta'),
                    ),
                    const SizedBox(width: 8),
                    _buildPrioridadeChip(
                      'Média',
                      Colors.orange,
                      Icons.remove,
                      prioridadeSelecionada == 'Média',
                      () => setState(() => prioridadeSelecionada = 'Média'),
                    ),
                    const SizedBox(width: 8),
                    _buildPrioridadeChip(
                      'Baixa',
                      Colors.green,
                      Icons.arrow_downward,
                      prioridadeSelecionada == 'Baixa',
                      () => setState(() => prioridadeSelecionada = 'Baixa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final novoTipo = controllerTipo.text.trim();

                final sucesso = await context
                    .read<CategoriaViewModel>()
                    .atualizarCategoria(
                      categoria.id,
                      novoTipo,
                      prioridadeSelecionada,
                    );

                if (sucesso && dialogContext.mounted) {
                  Navigator.pop(dialogContext);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Categoria atualizada!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  final viewModel = context.read<CategoriaViewModel>();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.mensagemErro ?? 'Erro'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    viewModel.limparErro();
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioridadeChip(
    String label,
    Color cor,
    IconData icone,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? cor.withValues(alpha:0.2) : Colors.grey[100],
            border: Border.all(
              color: isSelected ? cor : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icone,
                color: isSelected ? cor : Colors.grey[600],
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? cor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarExclusaoCategoria(
    BuildContext context,
    String categoriaId,
    int numTarefas,
  ) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text(
          numTarefas > 0
              ? 'Esta categoria possui $numTarefas tarefa${numTarefas != 1 ? "s" : ""}. '
                  'Ao excluir, todas as tarefas desta categoria também serão removidas.\n\n'
                  'Deseja continuar?'
              : 'Deseja realmente excluir esta categoria?',
        ),
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
      final sucesso = await context
          .read<CategoriaViewModel>()
          .deletarCategoria(categoriaId);

      if (sucesso && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Categoria excluída'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
         if (!context.mounted) return;
        final viewModel = context.read<CategoriaViewModel>();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.mensagemErro ?? 'Erro ao excluir'),
              backgroundColor: Colors.red,
            ),
          );
          viewModel.limparErro();
        }
      }
    }
  }
}