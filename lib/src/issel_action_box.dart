import 'package:flutter/material.dart';

class IsselActionBox extends StatelessWidget {

  final String asset;
  final String title;
  final double height;
  final double width;
  final VoidCallback onTap;
  final VoidCallback? onDeleteTap;
  final double borderRadius;
  final Color? color;

  const IsselActionBox({
    super.key,
    required this.asset,
    required this.title,
    required this.height,
    required this.width,
    required this.onTap,
    this.borderRadius = 20,
    this.onDeleteTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          padding: EdgeInsets.all(height * 0.05),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (onDeleteTap != null)
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  onPressed: onDeleteTap,
                  icon: Icon(Icons.delete, color: Colors.red,)
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Image.asset(asset, height: height * 0.45, width: height * 0.45,),
                  SizedBox(
                      height: height * 0.20,
                      child: Center(
                          child: Text(
                              title,
                              style: textTheme.titleLarge?.copyWith(fontSize: height * 0.09),
                              textAlign: TextAlign.center
                          )
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
