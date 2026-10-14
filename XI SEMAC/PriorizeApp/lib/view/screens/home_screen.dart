import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:priorize/viewmodel/tarefa_viewmodel.dart';
import 'package:priorize/viewmodel/categoria_viewmodel.dart';
import '../widgets/tarefa_card.dart';
import '../widgets/adicionar_tarefa_dialog.dart';
import '../widgets/filtro_prioridade_sheet.dart';
import '../widgets/gerenciar_categorias_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tarefas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botão de filtro de prioridade
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltroPrioridade(context),
            tooltip: 'Filtrar por prioridade',
          ),
          // Botão de gerenciar categorias
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => _mostrarGerenciarCategorias(context),
            tooltip: 'Gerenciar categorias',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progresso
          _buildBarraProgresso(),
          
          // Chips de filtro por categoria
          _buildFiltrosCategorias(),
          
          // Lista de tarefas
          Expanded(
            child: _buildListaTarefas(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarAdicionarTarefa(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
    );
  }

  // Barra de progresso
  Widget _buildBarraProgresso() {
    return Consumer<TarefaViewModel>(
      builder: (context, viewModel, _) {
        final progresso = viewModel.progressoTarefas;
        final concluidas = viewModel.tarefasConcluidas;
        final total = viewModel.totalTarefas;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$concluidas/$total concluídas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(progresso * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progresso,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Chips de filtro por categoria
  Widget _buildFiltrosCategorias() {
    return Consumer2<CategoriaViewModel, TarefaViewModel>(
      builder: (context, categoriaVM, tarefaVM, _) {
        if (categoriaVM.categorias.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriaVM.categorias.length,
            itemBuilder: (context, index) {
              final categoria = categoriaVM.categorias[index];
              final isSelected = tarefaVM.categoriaIdSelecionada == categoria.id;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(categoria.tipo),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      tarefaVM.obterPorCategoria(categoria.id);
                    } else {
                      tarefaVM.limparFiltroCategoria();
                    }
                  },
                  selectedColor: Colors.blue.withValues(alpha: 0.2),
                  checkmarkColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Lista de tarefas
  Widget _buildListaTarefas() {
    return Consumer<TarefaViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.estaCarregando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.mensagemErro != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  viewModel.mensagemErro!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    viewModel.limparErro();
                    viewModel.carregarTarefas();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (viewModel.tarefas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma tarefa',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione uma nova tarefa para começar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = viewModel.tarefas[index];
            return TarefaCard(tarefa: tarefa);
          },
        );
      },
    );
  }

  void _mostrarAdicionarTarefa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AdicionarTarefaDialog(),
    );
  }

  void _mostrarFiltroPrioridade(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FiltroPrioridadeSheet(),
    );
  }

  void _mostrarGerenciarCategorias(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const GerenciarCategoriasSheet(),
    );
  }
}