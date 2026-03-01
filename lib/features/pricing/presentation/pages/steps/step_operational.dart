import 'package:flutter/material.dart';

class OperationalInput {
  final TextEditingController label = TextEditingController();
  final TextEditingController value = TextEditingController();

  void dispose() {
    label.dispose();
    value.dispose();
  }
}

class StepOperational extends StatefulWidget {
  final List<OperationalInput> inputs;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const StepOperational({
    super.key,
    required this.inputs,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<StepOperational> createState() => _StepOperationalState();
}

class _StepOperationalState extends State<StepOperational> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Outros Gastos e Impostos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Exemplos: luz, aluguel proporcional, embalagem, taxas de maquininha, etc.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (widget.inputs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Nenhum gasto operacional adicionado.'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.inputs.length,
              itemBuilder: (context, i) {
                final input = widget.inputs[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: input.label,
                          decoration: InputDecoration(
                            labelText: 'Descrição do gasto',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: input.value,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Valor (R\$)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.onRemove(i),
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
