import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/pricing/presentation/pages/princing_flow_page.dart';
import 'package:flutter_test_app/core/state/products_state.dart';
import 'package:flutter_test_app/features/home/domain/models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGridView = false;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ProductsState();

    return Scaffold(
      backgroundColor: const Color(0xFFF6EEF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produtos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                    icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                    tooltip: _isGridView ? 'Ver em lista' : 'Ver em grade',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Pesquisar produto...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListenableBuilder(
                  listenable: state,
                  builder: (context, _) {
                    final allItems = state.products;
                    final filteredItems = allItems.where((p) {
                      return p.name.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (allItems.isEmpty) {
                      return _buildEmptyState('Nenhum produto precificado ainda.');
                    }

                    if (filteredItems.isEmpty) {
                      return _buildEmptyState('Nenhum resultado para "$_searchQuery".');
                    }

                    return _isGridView 
                        ? _buildGridView(filteredItems)
                        : _buildListView(filteredItems);
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
            MaterialPageRoute(builder: (_) => const PricingFlowPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Precificar"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildListView(List<Product> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final p = items[index];
        return _buildProductCard(p, isGrid: false);
      },
    );
  }

  Widget _buildGridView(List<Product> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final p = items[index];
        return _buildProductCard(p, isGrid: true);
      },
    );
  }

  Widget _buildProductCard(Product p, {required bool isGrid}) {
    if (isGrid) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7DEE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.image_outlined, size: 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'R\$ ${p.finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE7DEE7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.black),
        ),
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          'R\$ ${p.finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
