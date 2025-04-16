import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogout;
  final VoidCallback? onLogout;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.showLogout = false,
    this.onLogout,
    this.backgroundColor = const Color(0xFF1A6C1A),
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.menu_book, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              "হালখাতা",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (showLogout)
              ElevatedButton(
                onPressed: onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('লগ আউট'),
              ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            color: const Color(0xFFFFC107), // Yellow line
          ),
        ));
  }
}
