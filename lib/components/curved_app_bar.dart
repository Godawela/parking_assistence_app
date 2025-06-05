import 'package:flutter/material.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final bool showSearchIcon;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final int notificationCount;

  const CurvedAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 120,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.onNotificationPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedAppBarClipper(),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
             Colors.black,
              Colors.blue,
          
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (leading != null) leading!,
                    if (leading == null && Navigator.canPop(context))
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: foregroundColor ?? Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: subtitle != null 
                            ? CrossAxisAlignment.start 
                            : CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: foregroundColor ?? Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: (foregroundColor ?? Colors.white).withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showSearchIcon)
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: foregroundColor ?? Colors.white,
                          size: 24,
                        ),
                        onPressed: onSearchPressed,
                      ),
                    if (onNotificationPressed != null)
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: foregroundColor ?? Colors.white,
                              size: 24,
                            ),
                            onPressed: onNotificationPressed,
                          ),
                          if (notificationCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  notificationCount > 99 ? '99+' : '$notificationCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

// Custom Clipper 
class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    
    // Create curved bottom
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}