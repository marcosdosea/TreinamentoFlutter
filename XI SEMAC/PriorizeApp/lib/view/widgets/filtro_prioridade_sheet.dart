import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:priorize/viewmodel/tarefa_viewmodel.dart';

class FiltroPrioridadeSheet extends StatelessWidget {
  const FiltroPrioridadeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TarefaViewModel>(
      builder: (context, viewModel, _) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtrar por prioridade',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Opção: Todas
                _buildOpcaoFiltro(
                  context,
                  titulo: 'Todas',
                  subtitulo: 'Mostrar todas as prioridades',
                  icone: Icons.list,
                  cor: Colors.blue,
                  isSelected: viewModel.prioridadeSelecionada == null,
                  onTap: () {
                    viewModel.limparFiltroPrioridade();
                    Navigator.pop(context);
                  },
                ),

                const Divider(),

                // Opção: Alta
                _buildOpcaoFiltro(
                  context,
                  titulo: 'Alta',
                  subtitulo: 'Tarefas de alta prioridade',
                  icone: Icons.arrow_upward,
                  cor: Colors.red,
                  isSelected: viewModel.prioridadeSelecionada == 'Alta',
                  onTap: () {
                    viewModel.filtrarPorPrioridade('Alta');
                    Navigator.pop(context);
                  },
                ),

                // Opção: Média
                _buildOpcaoFiltro(
                  context,
                  titulo: 'Média',
                  subtitulo: 'Tarefas de média prioridade',
                  icone: Icons.remove,
                  cor: Colors.orange,
                  isSelected: viewModel.prioridadeSelecionada == 'Média',
                  onTap: () {
                    viewModel.filtrarPorPrioridade('Média');
                    Navigator.pop(context);
                  },
                ),

                // Opção: Baixa
                _buildOpcaoFiltro(
                  context,
                  titulo: 'Baixa',
                  subtitulo: 'Tarefas de baixa prioridade',
                  icone: Icons.arrow_downward,
                  cor: Colors.green,
                  isSelected: viewModel.prioridadeSelecionada == 'Baixa',
                  onTap: () {
                    viewModel.filtrarPorPrioridade('Baixa');
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpcaoFiltro(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required Color cor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withAlpha(128),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: cor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? cor : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: cor),
          ],
        ),
      ),
    );
  }
}
