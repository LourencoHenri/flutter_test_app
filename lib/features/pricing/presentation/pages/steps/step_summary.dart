import 'package:flutter/material.dart';

class StepSummary extends StatelessWidget {
  final String productName;
  final double materialsTotal;
  final double laborTotal;
  final double operationalTotal;

  const StepSummary({
    super.key,
    required this.productName,
    required this.materialsTotal,
    required this.laborTotal,
    required this.operationalTotal,
  });

  double get grandTotal => materialsTotal + laborTotal + operationalTotal;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo Geral',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _SummaryTile(
            label: 'Produto',
            value: productName.isEmpty ? 'Sem nome' : productName,
            isText: true,
          ),
          const Divider(),
          _SummaryTile(label: 'Materiais', value: materialsTotal),
          _SummaryTile(label: 'Mão de Obra', value: laborTotal),
          _SummaryTile(label: 'Gastos Operacionais', value: operationalTotal),
          const Divider(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Custo total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'R\$ ${grandTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isText;

  const _SummaryTile({
    required this.label,
    required this.value,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            isText
                ? value.toString()
                : 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
