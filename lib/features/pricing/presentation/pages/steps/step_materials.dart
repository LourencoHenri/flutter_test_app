import 'package:flutter/material.dart';

class MaterialInput {
  final TextEditingController name = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController price = TextEditingController();

  void dispose() {
    name.dispose();
    quantity.dispose();
    price.dispose();
  }
}

class StepMaterials extends StatefulWidget {
  final List<MaterialInput> materialInputs;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const StepMaterials({
    super.key,
    required this.materialInputs,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<StepMaterials> createState() => _StepMaterialsState();
}

class _StepMaterialsState extends State<StepMaterials> {
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
                'Materiais e Insumos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.materialInputs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Nenhum material adicionado.'),
              ),
            )
          else
            ...widget.materialInputs.asMap().entries.map((entry) {
              final i = entry.key;
              final m = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: m.name,
                              decoration: const InputDecoration(labelText: 'Material'),
                            ),
                          ),
                          IconButton(
                            onPressed: () => widget.onRemove(i),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: m.quantity,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Qtde'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: m.price,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Preço/Unit (R\$)'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
