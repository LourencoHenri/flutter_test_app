import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/pricing/presentation/pages/princing_flow_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      6,
      (i) => ProdutoUi(nome: 'Nome do produto', preco: 300.00),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6EEF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              const SizedBox(height: 6),
              const Text(
                'Produtos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final p = items[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        leading: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7DEE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          p.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'R\$ ${p.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PricingFlowPage(),
      ),
    );
  },
  icon: const Icon(Icons.add),
  label: const Text("Precificar"),
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ProdutoUi {
  final String nome;
  final double preco;
  ProdutoUi({required this.nome, required this.preco});
}
