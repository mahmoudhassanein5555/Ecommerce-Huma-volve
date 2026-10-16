import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<Color> colors;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
  });

    factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
     imageUrl: (json['images'] as List).isNotEmpty
    ? json['images'][0].toString()
    : '',
      colors: [Colors.black],
      sizes: ['One Size'],
    );
  }
}


final dummyProducts = [
  Product(
    id: '1',
    name: 'Classic White Sneakers',
    description: 'Comfortable and stylish white sneakers for everyday use.',
    price: 59.99,
    imageUrl: 'https://picsum.photos/seed/sneakers/300/300',
    colors: [Colors.white, Colors.black, Colors.grey],
    sizes: ['40', '41', '42', '43'],
  ),
  Product(
    id: '2',
    name: 'Denim Jacket',
    description: 'A classic denim jacket that never goes out of style.',
    price: 89.99,
    imageUrl: 'https://picsum.photos/seed/jacket/300/300',
    colors: [Colors.blue, Colors.black],
    sizes: ['S', 'M', 'L', 'XL'],
  ),
  Product(
    id: '3',
    name: 'Wireless Headphones',
    description: 'High-quality noise-canceling wireless headphones.',
    price: 199.99,
    imageUrl: 'https://picsum.photos/seed/headphones/300/300',
    colors: [Colors.black, Colors.grey],
    sizes: ['One Size'],
  ),
  Product(
    id: '4',
    name: 'Smart Watch',
    description: 'Stay connected and track your fitness with this smart watch.',
    price: 149.99,
    imageUrl: 'https://picsum.photos/seed/watch/300/300',
    colors: [Colors.black, Colors.blue, Colors.pink],
    sizes: ['One Size'],
  ),
];

class CartItem {
  final Product product;
  final int quantity;
  final Color selectedColor;
  final String selectedSize;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });
}

final dummyCart = [
  CartItem(
    product: dummyProducts[0],
    quantity: 1,
    selectedColor: Colors.white,
    selectedSize: '42',
  ),
  CartItem(
    product: dummyProducts[2],
    quantity: 2,
    selectedColor: Colors.black,
    selectedSize: 'One Size',
  ),
];

class UserProfile {
  final String name;
  final String email;
  final String profilePictureUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
  });
}

final dummyUser = UserProfile(
  name: 'John Doe',
  email: 'john.doe@example.com',
  profilePictureUrl: 'https://picsum.photos/seed/user/150/150',
);

final dummyCategories = [
  'All',
  'Shoes',
  'Clothing',
  'Accessories',
  'Electronics',
];
