class VendingMachineService {
  final Map<String, int> _inventory = {};

  void stockItem(String item, int quantity) {
    if (_inventory.containsKey(item)) {
      _inventory[item] = _inventory[item]! + quantity;
    } else {
      _inventory[item] = quantity;
    }
  }

  bool dispenseItem(String item) {
    if (_inventory.containsKey(item) && _inventory[item]! > 0) {
      _inventory[item] = _inventory[item]! - 1;
      return true;
    }
    return false;
  }

  int getItemCount(String item) {
    return _inventory[item] ?? 0;
  }
}
