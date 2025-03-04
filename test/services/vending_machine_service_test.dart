import 'package:flutter_test/flutter_test.dart';
import 'package:red_green_ai/services/can.dart';
import 'package:red_green_ai/services/index_out_of_range_exception.dart';
import 'package:red_green_ai/services/insufficient_funds_exception.dart';
import 'package:red_green_ai/services/inventory.dart';
import 'package:red_green_ai/services/sold_out_exception.dart';
import 'package:red_green_ai/services/vending_machine_service.dart';

void main() {
  group('VendingMachineService', () {
    late VendingMachineService vendingMachineService;
    late List<Inventory> list;
    setUp(() {
      list = [
        Inventory(can: Can(name: 'Coke', price: 150), amount: 2),
        Inventory(can: Can(name: 'Sprite', price: 120), amount: 3),
        Inventory(can: Can(name: 'Tea', price: 130), amount: 3),
        Inventory(can: Can(name: 'Water', price: 100), amount: 3),
      ];
      vendingMachineService = VendingMachineService(list);
    });

    test('コーラは150入れないと買えない', () {
      vendingMachineService.insertMoney(100); // お金を挿入
      expect(
        () => vendingMachineService.fetch(index: 0),
        throwsA(isA<InsufficientFundsException>()),
      );
      vendingMachineService.insertMoney(50); // 追加のお金を挿入
      final can = vendingMachineService.fetch(index: 0);
      expect(can, Can(name: 'Coke', price: 150));
    });

    test('Spriteは120入れないと買えない', () {
      vendingMachineService.insertMoney(100); // お金を挿入
      expect(
        () => vendingMachineService.fetch(index: 1),
        throwsA(isA<InsufficientFundsException>()),
      );
      vendingMachineService.insertMoney(20); // 追加のお金を挿入
      final can = vendingMachineService.fetch(index: 1);
      expect(can, Can(name: 'Sprite', price: 120));
    });

    test('Amount以上の購入はできない', () {
      final can = Can(name: 'coffee', price: 200);
      vendingMachineService.setInventory([Inventory(can: can, amount: 2)]);
      vendingMachineService.insertMoney(1000);
      expect(vendingMachineService.fetch(index: 0), can);
      expect(vendingMachineService.fetch(index: 0), can);
      expect(
        () => vendingMachineService.fetch(index: 0),
        throwsA(isA<SoldOutException>()),
      );
    });

    test('お釣りが出る', () {
      vendingMachineService.insertMoney(200);
      final can = vendingMachineService.fetch(index: 0);
      expect(can, Can(name: 'Coke', price: 150));
      final change = vendingMachineService.change();
      expect(change, 50);
    });

    test('ジュースのラインナップは変更可能', () {
      final fanta = Can(name: 'Fanta', price: 180);
      final tea = Can(name: 'tea', price: 200);
      vendingMachineService.setInventory([
        Inventory(can: fanta, amount: 1),
        Inventory(can: tea, amount: 1),
      ]);
      vendingMachineService.insertMoney(380);
      expect(vendingMachineService.fetch(index: 0), fanta);
      expect(vendingMachineService.fetch(index: 1), tea);
      expect(vendingMachineService.change(), 0);
    });

    test('存在しないジュースを取得しようとするとエラー', () {
      vendingMachineService.insertMoney(200);
      expect(
        () => vendingMachineService.fetch(index: list.length),
        throwsA(isA<IndexOutOfRangeException>()),
      );
    });

    test('お金を挿入しなければジュースを取得できない', () {
      expect(
        () => vendingMachineService.fetch(index: 0),
        throwsA(isA<InsufficientFundsException>()),
      );
    });
  });
}
