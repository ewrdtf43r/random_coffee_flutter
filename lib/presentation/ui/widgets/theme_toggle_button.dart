import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeToggleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ThemeToggleButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF5CBCE5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: const Color(0x0D724276),
              blurRadius: 10,
              offset: Offset.zero,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SvgPicture.asset(
            'lib/presentation/ui/icons/theme_toggle_button.svg', //  <---  Исправлено
            width: 48,
            height: 48,
          ),
        ),
      ),
    );
  }
}