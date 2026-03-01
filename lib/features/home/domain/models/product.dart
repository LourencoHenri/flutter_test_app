class Product {
  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final List<MaterialItem> materials;
  final Labor labor;
  final List<OperationalCost> operationalCosts;
  final double finalPrice;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.materials,
    required this.labor,
    required this.operationalCosts,
    required this.finalPrice,
  });
}

class MaterialItem {
  final String name;
  final double quantity;
  final double unitPrice;

  MaterialItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class Labor {
  final double hours;
  final double hourlyRate;

  Labor({
    required this.hours,
    required this.hourlyRate,
  });

  double get total => hours * hourlyRate;
}

class OperationalCost {
  final String label;
  final double value;

  OperationalCost({
    required this.label,
    required this.value,
  });
}
