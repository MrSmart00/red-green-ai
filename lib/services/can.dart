class Can {
  final String name;
  final int price;
  Can({required this.name, required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Can && other.name == name && other.price == price;

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
