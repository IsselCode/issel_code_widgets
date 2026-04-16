import 'package:flutter/material.dart';

/// Contenedor visual para mostrar una imagen local o un favicon de red.
///
/// Si [network] tiene valor, carga el favicon del dominio indicado usando el
/// servicio de Google. Si esa carga falla, muestra [asset] como imagen de
/// respaldo.
class IsselAssetContainer extends StatelessWidget {
  /// Altura total del contenedor.
  final double height;

  /// Ancho total del contenedor.
  final double width;

  /// Ruta del asset local mostrado directamente o usado como respaldo.
  final String? asset;

  /// Dominio utilizado para cargar el favicon desde red.
  final String? network;

  /// Color de fondo opcional del contenedor.
  ///
  /// Si es null, usa [ColorScheme.surface].
  final Color? color;

  /// Crea un contenedor para mostrar una imagen local o un favicon.
  ///
  /// Debe proporcionarse al menos [asset] o [network]. Cuando [network] tiene
  /// valor, [asset] se usa como imagen de respaldo si la carga de red falla.
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
                blurRadius: 10, color: colorScheme.onSurface.withAlpha(60))
          ]),
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
          : Image.asset(
              asset!,
              fit: BoxFit.contain,
            ),
    );
  }
}
