import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/state/products_state.dart';
import 'package:flutter_test_app/features/home/domain/models/product.dart';
import 'steps/step_product.dart';
import 'steps/step_materials.dart';
import 'steps/step_labor.dart';
import 'steps/step_operational.dart';
import 'steps/step_summary.dart';

class PricingFlowPage extends StatefulWidget {
  const PricingFlowPage({super.key});

  @override
  State<PricingFlowPage> createState() => _PricingFlowPageState();
}

class _PricingFlowPageState extends State<PricingFlowPage> {
  static const int _totalSteps = 5;

  final PageController _pageCtrl = PageController();
  int _stepIndex = 0;

  // Step 1 Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  // Step 2 Controllers
  final List<MaterialInput> _materialInputs = [];

  // Step 3 Controllers
  final TextEditingController _laborHoursCtrl = TextEditingController();
  final TextEditingController _laborRateCtrl = TextEditingController();

  // Step 4 Controllers
  final List<OperationalInput> _operationalInputs = [];

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    for (var m in _materialInputs) {
      m.dispose();
    }
    _laborHoursCtrl.dispose();
    _laborRateCtrl.dispose();
    for (var o in _operationalInputs) {
      o.dispose();
    }
    super.dispose();
  }

  double get _materialsTotal {
    double total = 0;
    for (var m in _materialInputs) {
      final q = double.tryParse(m.quantity.text) ?? 0;
      final p = double.tryParse(m.price.text) ?? 0;
      total += q * p;
    }
    return total;
  }

  double get _laborTotal {
    final h = double.tryParse(_laborHoursCtrl.text) ?? 0;
    final r = double.tryParse(_laborRateCtrl.text) ?? 0;
    return h * r;
  }

  double get _operationalTotal {
    double total = 0;
    for (var o in _operationalInputs) {
      total += double.tryParse(o.value.text) ?? 0;
    }
    return total;
  }

  Future<void> _goTo(int index) async {
    if (index < 0 || index >= _totalSteps) return;
    await _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_stepIndex < _totalSteps - 1) {
      _goTo(_stepIndex + 1);
    } else {
      _saveProduct();
    }
  }

  void _saveProduct() {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.isEmpty ? 'Novo Produto' : _nameCtrl.text,
      description: _descriptionCtrl.text,
      materials: _materialInputs.map((m) {
        return MaterialItem(
          name: m.name.text,
          quantity: double.tryParse(m.quantity.text) ?? 0,
          unitPrice: double.tryParse(m.price.text) ?? 0,
        );
      }).toList(),
      labor: Labor(
        hours: double.tryParse(_laborHoursCtrl.text) ?? 0,
        hourlyRate: double.tryParse(_laborRateCtrl.text) ?? 0,
      ),
      operationalCosts: _operationalInputs.map((o) {
        return OperationalCost(
          label: o.label.text,
          value: double.tryParse(o.value.text) ?? 0,
        );
      }).toList(),
      finalPrice: _materialsTotal + _laborTotal + _operationalTotal,
    );

    ProductsState().addProduct(newProduct);
    Navigator.of(context).pop();
  }

  void _back() {
    if (_stepIndex > 0) _goTo(_stepIndex - 1);
  }

  String get _stepTitle {
    switch (_stepIndex) {
      case 0:
        return 'Product';
      case 1:
        return 'Materials';
      case 2:
        return 'Labor';
      case 3:
        return 'Operational Cost';
      case 4:
        return 'Summary';
      default:
        return 'Pricing';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _stepIndex == _totalSteps - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF6EEF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6EEF6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _stepTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress + step chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (_stepIndex + 1) / _totalSteps,
                      minHeight: 8,
                      backgroundColor: Colors.black.withOpacity(0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black.withOpacity(0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(_totalSteps, (i) {
                      final active = i == _stepIndex;
                      final done = i < _stepIndex;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == _totalSteps - 1 ? 0 : 8,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () => _goTo(i),
                            child: Container(
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.black.withOpacity(0.78)
                                    : (done
                                          ? Colors.black.withOpacity(0.10)
                                          : Colors.white.withOpacity(0.70)),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: active
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.70),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Steps content
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(), // wizard feel
                onPageChanged: (i) => setState(() => _stepIndex = i),
                children: [
                  StepProduct(
                    nameController: _nameCtrl,
                    descriptionController: _descriptionCtrl,
                  ),
                  StepMaterials(
                    materialInputs: _materialInputs,
                    onAdd: () => setState(() => _materialInputs.add(MaterialInput())),
                    onRemove: (idx) => setState(() {
                      _materialInputs[idx].dispose();
                      _materialInputs.removeAt(idx);
                    }),
                  ),
                  StepLabor(
                    hoursController: _laborHoursCtrl,
                    rateController: _laborRateCtrl,
                  ),
                  StepOperational(
                    inputs: _operationalInputs,
                    onAdd: () => setState(() => _operationalInputs.add(OperationalInput())),
                    onRemove: (idx) => setState(() {
                      _operationalInputs[idx].dispose();
                      _operationalInputs.removeAt(idx);
                    }),
                  ),
                  StepSummary(
                    productName: _nameCtrl.text,
                    materialsTotal: _materialsTotal,
                    laborTotal: _laborTotal,
                    operationalTotal: _operationalTotal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom controls
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _stepIndex == 0 ? null : _back,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.black.withOpacity(0.15)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.85),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(isLast ? 'Finish' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
