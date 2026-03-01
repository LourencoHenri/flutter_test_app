import 'package:flutter/material.dart';

/// Pricing Flow Page (UI-only)
/// Multi-step wizard using PageView:
/// 1) Product
/// 2) Materials
/// 3) Labor
/// 4) Operational Cost
/// 5) Summary
class PricingFlowPage extends StatefulWidget {
  const PricingFlowPage({super.key});

  @override
  State<PricingFlowPage> createState() => _PricingFlowPageState();
}

class _PricingFlowPageState extends State<PricingFlowPage> {
  static const int _totalSteps = 5;

  final PageController _pageCtrl = PageController();
  int _stepIndex = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
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
      // UI-only: final action could be "Save"
      Navigator.of(context).maybePop();
    }
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
                children: const [
                  _StepPlaceholder(
                    title: 'Step 1 — Product',
                    subtitle: 'Add image, name and description.',
                    icon: Icons.photo_camera_outlined,
                  ),
                  _StepPlaceholder(
                    title: 'Step 2 — Materials',
                    subtitle: 'Add materials and quantities.',
                    icon: Icons.inventory_2_outlined,
                  ),
                  _StepPlaceholder(
                    title: 'Step 3 — Labor',
                    subtitle: 'Set time and hourly rate.',
                    icon: Icons.timer_outlined,
                  ),
                  _StepPlaceholder(
                    title: 'Step 4 — Operational Cost',
                    subtitle: 'Add packaging, fees, energy, etc.',
                    icon: Icons.receipt_long_outlined,
                  ),
                  _StepPlaceholder(
                    title: 'Step 5 — Summary',
                    subtitle: 'Review totals and confirm.',
                    icon: Icons.check_circle_outline,
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

/// Simple placeholder for UI-only steps.
/// Later you replace these with:
/// StepProduct(), StepMaterials(), StepLabor(), StepOperationalCost(), StepSummary()
class _StepPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _StepPlaceholder({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 44, color: Colors.black.withOpacity(0.55)),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.black.withOpacity(0.60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
