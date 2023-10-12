import 'package:flutter/material.dart';

/// Class GradientText untuk membuat sebuah gradientText dengan memanggil
/// class GradientText saja yang memiliki nilai Text, Gradient, dan style
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  /// Deklarasi Variable untuk String Text
  final String text;

  /// Deklarasi Variable untuk TextStyle
  final TextStyle? style;

  /// Deklarasi Variable untuk Gradient
  final Gradient gradient;

  @override

  /// Widget untuk tampilan dari class GradientText
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
