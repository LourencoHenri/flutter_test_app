import 'package:flutter/material.dart';

class StepLabor extends StatelessWidget {
  final TextEditingController hoursController;
  final TextEditingController rateController;

  const StepLabor({
    super.key,
    required this.hoursController,
    required this.rateController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mão de Obra e Tempo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: hoursController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Tempo gasto (horas)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: rateController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Taxa Horária (R\$/hora)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sugestão: calcule o seu salário mensal desejado dividido pela quantidade de horas trabalhadas por mês.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
