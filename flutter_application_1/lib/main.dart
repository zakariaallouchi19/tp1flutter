import 'package:flutter/material.dart';
import 'dart:io';

class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return 'ID: $id, Name: $name, Price: \$${price.toStringAsFixed(2)}';
  }
}

void main() {
  List<Product> inventory = [
    Product(1, "Product 1", 10.99),
    Product(2, "Product 2", 20.49),
    Product(3, "Product 3", 5.99),
    Product(4, "Product 4", 15.79),
    Product(5, "Product 5", 12.99),
  ];

  Map<int, Product> productMap = Map.fromIterable(
    inventory,
    key: (product) => product.id,
    value: (product) => product,
  );

  Set<String> productNames = inventory.map((product) => product.name).toSet();

  displayInventory(inventory);

  stdout.write("Enter product ID to search: ");
  int searchId = int.parse(stdin.readLineSync()!);

  if (productMap.containsKey(searchId)) {
    print("Product details:");
    print(productMap[searchId]);
  } else {
    print("Product with ID $searchId not found.");
  }

  double totalValue = calculateTotalValue(inventory);
  print("Total inventory value: \$${totalValue.toStringAsFixed(2)}");

  // Save inventory to file
  saveInventoryToFile(inventory);

  // Load inventory from file
  List<Product>? loadedInventory = loadInventoryFromFile();
  if (loadedInventory != null) {
    print("\nLoaded inventory from file:");
    displayInventory(loadedInventory);
  }
}

void displayInventory(List<Product> inventory) {
  print("Inventory:");
  inventory.forEach((product) => print(product));
}

double calculateTotalValue(List<Product> inventory) {
  return inventory.fold(0, (total, product) => total + product.price);
}

void saveInventoryToFile(List<Product> inventory) {
  File file = File('inventory.txt');
  IOSink sink = file.openWrite();
  inventory.forEach((product) {
    sink.writeln("${product.id},${product.name},${product.price}");
  });
  sink.close();
}

List<Product>? loadInventoryFromFile() {
  try {
    File file = File('inventory.txt');
    List<String> lines = file.readAsLinesSync();
    List<Product> loadedInventory = [];
    lines.forEach((line) {
      List<String> parts = line.split(',');
      if (parts.length == 3) {
        int id = int.parse(parts[0]);
        String name = parts[1];
        double price = double.parse(parts[2]);
        loadedInventory.add(Product(id, name, price));
      }
    });
    return loadedInventory;
  } catch (e) {
    print("Error loading inventory from file: $e");
    return null;
  }
}
