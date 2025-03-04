import 'can.dart';
import 'index_out_of_range_exception.dart';
import 'insufficient_funds_exception.dart';
import 'inventory.dart';
import 'sold_out_exception.dart';

class VendingMachineService {
  int _money = 0;
  List<Inventory> _inventory;

  VendingMachineService(List<Inventory> inventory) : _inventory = inventory;

  void insertMoney(int amount) {
    _money += amount;
  }

  Can fetch({required int index}) {
    if (index < 0 || index >= _inventory.length) {
      throw IndexOutOfRangeException();
    }
    if (_money < _inventory[index].can.price) {
      throw InsufficientFundsException();
    }
    if (_inventory[index].amount <= 0) {
      throw SoldOutException();
    }
    _money -= _inventory[index].can.price;
    _inventory[index].amount -= 1;
    return _inventory[index].can;
  }

  int change() {
    int change = _money;
    _money = 0;
    return change;
  }

  void setInventory(List<Inventory> inventory) {
    _inventory = inventory;
  }
}
