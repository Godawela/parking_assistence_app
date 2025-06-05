import 'package:flutter/material.dart';

class CurvedBackgroundBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color? startColor;
  final Color? endColor;

  const CurvedBackgroundBar({
    super.key,
    this.height = 50,
    this.startColor = Colors.black,
    this.endColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            startColor!,
            endColor!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
