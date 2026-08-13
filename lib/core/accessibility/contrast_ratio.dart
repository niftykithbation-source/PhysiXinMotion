import 'dart:math' as math;

/// Blueprint §7 Step 7.3: WCAG 2.x contrast-ratio math, pure Dart (no
/// Flutter import — callers extract r/g/b channels from a Color
/// themselves, keeping this testable in isolation like the physics/
/// gamification engines).
///
/// Minimum ratios per WCAG 2.1 AA:
const kWcagAaNormalText = 4.5;
const kWcagAaLargeTextOrUiComponent = 3.0;

double _linearizeChannel(int value) {
  final c = value / 255.0;
  return c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
}

double relativeLuminance({required int r, required int g, required int b}) {
  return 0.2126 * _linearizeChannel(r) +
      0.7152 * _linearizeChannel(g) +
      0.0722 * _linearizeChannel(b);
}

/// The WCAG contrast ratio between two colors, order-independent, in the
/// range [1, 21].
double contrastRatio({
  required int r1,
  required int g1,
  required int b1,
  required int r2,
  required int g2,
  required int b2,
}) {
  final l1 = relativeLuminance(r: r1, g: g1, b: b1);
  final l2 = relativeLuminance(r: r2, g: g2, b: b2);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}
