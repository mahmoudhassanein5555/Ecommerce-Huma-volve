import 'package:flutter/material.dart';

import 'models/product.dart';

final dummyProducts = [
  Product(
    id: '1',
    name: 'Classic White Sneakers',
    description: 'Comfortable and stylish white sneakers for everyday use.',
    categoryId: '4',
    category: 'Shoes',
    price: 59.99,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    colors: [Colors.white, Colors.black, Colors.grey],
    sizes: ['40', '41', '42', '43'],
  ),
  Product(
    id: '2',
    name: 'Denim Jacket',
    description: 'A classic denim jacket that never goes out of style.',
    categoryId: '1',
    category: 'Clothing',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=800&q=80',
    colors: [Colors.blue, Colors.black],
    sizes: ['S', 'M', 'L', 'XL'],
  ),
  Product(
    id: '3',
    name: 'Wireless Headphones',
    description: 'High-quality noise-canceling wireless headphones.',
    categoryId: '2',
    category: 'Electronics',
    price: 199.99,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    colors: [Colors.black, Colors.grey],
    sizes: ['One Size'],
  ),
  Product(
    id: '4',
    name: 'Smart Watch',
    description: 'Stay connected and track your fitness with this smart watch.',
    categoryId: '2',
    category: 'Accessories',
    price: 149.99,
    imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=800&q=80',
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
  profilePictureUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&h=150&q=80',
);
