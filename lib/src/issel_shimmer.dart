import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder rectangular con efecto shimmer.
///
/// Aparece después de [delay], que por defecto es de 50 ms.
class IsselShimmer extends StatefulWidget {
  /// Ancho del placeholder.
  final double width;

  /// Altura del placeholder.
  final double height;

  /// Tiempo de espera antes de mostrar el shimmer.
  final Duration delay;

  /// Crea un placeholder shimmer con tamaño fijo.
  const IsselShimmer(
      {super.key,
      required this.width,
      required this.height,
      this.delay = const Duration(milliseconds: 50)});

  @override
  State<IsselShimmer> createState() => _IsselShimmerState();
}

class _IsselShimmerState extends State<IsselShimmer> {
  bool show = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.delay, () {
      if (mounted) setState(() => show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? Shimmer.fromColors(
            baseColor: const Color(0xffcfcfcf).withAlpha(150),
            highlightColor: const Color(0xffcfcfcf).withAlpha(50),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ))
        : SizedBox.shrink();
  }
}
