import 'package:flutter/material.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {

  const TAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final IconData? leadingIcon;
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent, // ✅ important
      surfaceTintColor: Colors.transparent, // ✅ Flutter 3+
      leading: showBackArrow
          ? IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      )
          : leadingIcon != null
          ? IconButton(
        onPressed: leadingOnPressed,
        icon: Icon(leadingIcon, color: Colors.white),
      )
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
