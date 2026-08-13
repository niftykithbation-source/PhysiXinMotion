/// Thrown by [ContentValidator] (or during content-pack parsing) when a
/// content pack fails the Step 2.3 integrity checks. Carries enough context
/// ([field], [itemId]) to point at exactly what's wrong, per the
/// "never a silent partial import" requirement in the blueprint / CLAUDE.md.
class ContentValidationException implements Exception {
  final String field;
  final String itemId;
  final String message;

  const ContentValidationException(this.field, this.itemId, this.message);

  @override
  String toString() => 'ContentValidationException: [$field] ($itemId) $message';
}
