import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartBadgeButton extends StatelessWidget {
  final int Function() count;
  final VoidCallback onPressed;

  const CartBadgeButton({super.key, required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: onPressed,
        ),
        Obx(() {
          final c = count();
          if (c == 0) return const SizedBox.shrink();
          return Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.redAccent, shape: BoxShape.circle),
              child: Text('$c',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          );
        }),
      ],
    );
  }
}
