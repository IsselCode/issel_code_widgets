import 'package:flutter/material.dart';

class IsselAssetContainer extends StatelessWidget {

  final double height;
  final double width;
  final String? asset;
  final String? network;
  final Color? color;

  IsselAssetContainer({
    super.key,
    this.asset,
    this.network,
    this.height = 80,
    this.width = 80,
    this.color,
  }) {
    assert(asset != null || network != null, "Imagen requerida");
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: colorScheme.onSurface.withAlpha(60)
            )
          ]
      ),
      padding: const EdgeInsets.all(10.0),
      child: network != null
          ? Image.network(
        'https://www.google.com/s2/favicons?sz=256&domain=${network}',
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            asset!,
            fit: BoxFit.contain,
          );
        },
      )
          : Image.asset(asset!, fit: BoxFit.contain,),
    );
  }
}
