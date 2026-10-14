import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:priorize/viewmodel/tarefa_viewmodel.dart';
import 'package:priorize/viewmodel/categoria_viewmodel.dart';

class AdicionarTarefaDialog extends StatefulWidget {
  const AdicionarTarefaDialog({super.key});

  @override
  State<AdicionarTarefaDialog> createState() => _AdicionarTarefaDialogState();
}

class _AdicionarTarefaDialogState extends State<AdicionarTarefaDialog> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    // Inicializa a categoria selecionada com a primeira da lista, se houver.
    final categoriaVM = context.read<CategoriaViewModel>();
    if (categoriaVM.categorias.isNotEmpty) {
      _categoriaSelecionada = categoriaVM.categorias.first.id;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título do dialog
              const Text(
                'Nova Tarefa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Campo Título
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ex: Passear com Dog',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              
              // Campo Descrição
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Detalhes da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              
              // Dropdown Categoria - Versão Detalhada (Ajustada)
              Consumer<CategoriaViewModel>(
                builder: (context, categoriaVM, _) {
                  if (categoriaVM.categorias.isEmpty) {
                    return const Text(
                      'Nenhuma categoria disponível. Crie uma primeiro!',
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  // Garante que uma categoria esteja selecionada por padrão
                  if (_categoriaSelecionada == null || !categoriaVM.categorias.any((cat) => cat.id == _categoriaSelecionada)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _categoriaSelecionada = categoriaVM.categorias.first.id;
                      });
                    });
                  }

                    return DropdownButtonFormField<String>(
                      initialValue: _categoriaSelecionada,
                      decoration: InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: categoriaVM.categorias.map((categoria) {
                      Color cor;
                      IconData icone;

                      // Lógica para determinar ícone e cor com base no nível de prioridade
                      switch (categoria.nivelPrioridade) {
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

                      return DropdownMenuItem(
                        value: categoria.id,
                        // Conteúdo detalhado do DropdownMenuItem (Row com Ícone e Prioridade)
                        child: Row(
                          children: [
                            Icon(icone, color: cor, size: 18),
                            const SizedBox(width: 8),
                            Text(categoria.tipo),
                            const SizedBox(width: 4),
                            Text(
                              '(${categoria.nivelPrioridade})',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _categoriaSelecionada = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _adicionarTarefa,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _adicionarTarefa() async {
    // 1. Validação simples
    if (_tituloController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O título não pode ser vazio.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    if (_categoriaSelecionada == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione uma categoria'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final viewModel = context.read<TarefaViewModel>();
    
    // 2. Chamada da função com a prioridade
    final sucesso = await viewModel.adicionarTarefa(
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      idCategoria: _categoriaSelecionada!,
      //prioridade: _prioridadeSelecionada,
    );

    // 3. Feedback e fechamento do dialog
    if (sucesso && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Tarefa adicionada!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.mensagemErro ?? 'Erro ao adicionar a tarefa'),
          backgroundColor: Colors.red,
        ),
      );
      viewModel.limparErro();
    }
  }
}