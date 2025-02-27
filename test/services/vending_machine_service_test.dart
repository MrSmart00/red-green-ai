import 'package:flutter_test/flutter_test.dart';
import 'package:red_green_ai/services/vending_machine_service.dart';

void main() {
  group('VendingMachineService', () {
    late VendingMachineService vendingMachineService;

    setUp(() {
      vendingMachineService = VendingMachineService();
    });

    test('stockItem adds items to the inventory', () {
      vendingMachineService.stockItem('Coke', 10);
      expect(vendingMachineService.getItemCount('Coke'), 10);
    });

    test('dispenseItem dispenses an item if available', () {
      vendingMachineService.stockItem('Coke', 10);
      bool result = vendingMachineService.dispenseItem('Coke');
      expect(result, true);
      expect(vendingMachineService.getItemCount('Coke'), 9);
    });

    test('dispenseItem returns false if item is not available', () {
      bool result = vendingMachineService.dispenseItem('Pepsi');
      expect(result, false);
    });

    test('getItemCount returns the correct count of an item', () {
      vendingMachineService.stockItem('Coke', 10);
      expect(vendingMachineService.getItemCount('Coke'), 10);
      expect(vendingMachineService.getItemCount('Pepsi'), 0);
    });
  });
}
