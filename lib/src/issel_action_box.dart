import 'package:flutter/material.dart';

/// Widget de acción tipo tarjeta que muestra una imagen local y un título.
///
/// Toda la caja es presionable mediante [onTap]. Cuando se proporciona
/// [onDeleteTap], se muestra un botón con icono de eliminar en la esquina
/// superior derecha.
class IsselActionBox extends StatelessWidget {
  /// Ruta del asset utilizado por [Image.asset].
  final String asset;

  /// Texto mostrado debajo de la imagen.
  final String title;

  /// Altura total de la caja de acción.
  ///
  /// También define el padding interno, el tamaño de la imagen y el tamaño de
  /// fuente del título.
  final double height;

  /// Ancho total de la caja de acción.
  final double width;

  /// Callback invocado cuando se presiona la caja de acción.
  final VoidCallback onTap;

  /// Callback opcional invocado cuando se presiona el icono de eliminar.
  ///
  /// Si es null, el icono de eliminar no se renderiza.
  final VoidCallback? onDeleteTap;

  /// Radio aplicado a la caja y al borde del efecto táctil.
  final double borderRadius;

  /// Color de fondo opcional de la caja.
  ///
  /// Si es null, usa [ColorScheme.surface].
  final Color? color;

  /// Crea una caja de acción con imagen local, título y comportamiento táctil.
  ///
  /// Los parámetros [asset], [title], [height], [width] y [onTap] son
  /// requeridos. Proporciona [onDeleteTap] para mostrar la acción de eliminar.
  const IsselActionBox({
    super.key,
    required this.asset,
    required this.title,
    required this.height,
    required this.width,
    required this.onTap,
    this.borderRadius = 10,
    this.onDeleteTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      mouseCursor: SystemMouseCursors.click,
      child: Ink(
        padding: EdgeInsets.all(height * 0.05),
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: color ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (onDeleteTap != null)
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                    onPressed: onDeleteTap,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Image.asset(
                  asset,
                  height: height * 0.45,
                  width: height * 0.45,
                ),
                SizedBox(
                    height: height * 0.20,
                    child: Center(
                        child: Text(title,
                            style: textTheme.titleLarge
                                ?.copyWith(fontSize: height * 0.09),
                            textAlign: TextAlign.center)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
