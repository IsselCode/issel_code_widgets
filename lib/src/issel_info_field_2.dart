import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IsselInfoField2 extends StatelessWidget {

  final IconData icon;
  final String label;
  final double height;
  final Color? backColor;
  final bool copy;
  final VoidCallback? copied;

  const IsselInfoField2({
    super.key,
    required this.icon,
    required this.label,
    this.copy = false,
    this.copied,
    this.height = 50,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: backColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        spacing: 10,
        children: [
          // Icon
          Icon(icon, color: colorScheme.outline),
          // Text
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            )
          ),
          // Copy
          if (copy)
            Material(
              color: Colors.transparent.withOpacity(0.0001),
              shape: CircleBorder(),
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: copyToClipboard,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.copy_outlined, size: 16),
                ),
              ),
            )
        ],
      ),
    );
  }

  void copyToClipboard() {
    Clipboard.setData(
      ClipboardData(text: label)
    );
    copied?.call();
  }

}
