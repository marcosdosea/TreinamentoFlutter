import 'package:flutter/material.dart';

/// Este widget representa o botão de adicionar categoria.
/// Ele é separado propositalmente para fins educacionais,
/// permitindo demonstrar aos alunos como criar e montar um
/// botão que consome uma lógica existente em outro arquivo.
///
/// Na aula, basta usar:
// Row(
//   children: [
//     Aula04CriandoBotoes(
//       onPressed: () => _mostrarAdicionarCategoria(context),
//     ),
//     IconButton(
//       icon: const Icon(Icons.close),
//       onPressed: () => Navigator.pop(context),
//     ),
//   ],
// ),

class Aula04CriandoBotoes extends StatelessWidget {
  final VoidCallback onPressed;

  const Aula04CriandoBotoes({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Adicionar categoria',
      onPressed: onPressed,
    );
  }
}
