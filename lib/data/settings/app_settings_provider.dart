import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';

/// Blueprint §3.2 Settings — Appearance: Light/Dark/Match device, applies
/// instantly (no restart), persisted to app_settings so it survives a
/// relaunch.
class ThemeModeController extends StateNotifier<ThemeMode> {
  final AppDatabase db;

  ThemeModeController(this.db) : super(ThemeMode.system) {
    _load();
  }

  static const _key = 'settings:theme_mode';

  Future<void> _load() async {
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(_key)))
        .getSingleOrNull();
    if (row != null) state = _parse(row.value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: _serialize(mode)),
        );
  }

  static ThemeMode _parse(String value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String _serialize(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}

final themeModeControllerProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ThemeModeController(db);
});

/// Blueprint §3.2 / Risk #2 fix — disables chart animation and caps
/// rendered trial history at 10 points.
class SimpleGraphicsController extends StateNotifier<bool> {
  final AppDatabase db;

  SimpleGraphicsController(this.db) : super(false) {
    _load();
  }

  static const _key = 'settings:simple_graphics';
  static const capWhenEnabled = 10;

  /// Blueprint §7 Step 8 — low-spec performance pass: a Motion Lab session
  /// can accumulate an unbounded number of trials over time, and every one
  /// of them was being fed into the chart's spot list and the trial card
  /// list on every rebuild even with Simple graphics off. This baseline
  /// cap applies regardless of that setting; Simple graphics tightens it
  /// further to [capWhenEnabled].
  static const defaultTrialHistoryCap = 30;

  Future<void> _load() async {
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(_key)))
        .getSingleOrNull();
    if (row != null) state = row.value == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: enabled ? 'true' : 'false'),
        );
  }
}

final simpleGraphicsControllerProvider = StateNotifierProvider<SimpleGraphicsController, bool>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return SimpleGraphicsController(db);
});

/// Blueprint §7 Step 9 item 6 — lets a validator surface each quiz item's
/// Table-of-Specifications competency tag (and difficulty) via a dedicated
/// checklist screen, so curriculum alignment can be checked against
/// Appendix G without a separate spreadsheet. Off by default: this is a
/// reviewer-facing mode, not something a student/teacher session should
/// stumble into.
class ValidatorModeController extends StateNotifier<bool> {
  final AppDatabase db;

  ValidatorModeController(this.db) : super(false) {
    _load();
  }

  static const _key = 'settings:validator_mode';

  Future<void> _load() async {
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(_key)))
        .getSingleOrNull();
    if (row != null) state = row.value == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: enabled ? 'true' : 'false'),
        );
  }
}

final validatorModeControllerProvider = StateNotifierProvider<ValidatorModeController, bool>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return ValidatorModeController(db);
});

/// Blueprint constraint 5 — "No public student leaderboard by default.
/// app_settings.leaderboard_visible defaults false. Teacher must
/// explicitly opt in per class." Key matches that constraint verbatim.
class LeaderboardVisibilityController extends StateNotifier<bool> {
  final AppDatabase db;

  LeaderboardVisibilityController(this.db) : super(false) {
    _load();
  }

  static const _key = 'leaderboard_visible';

  Future<void> _load() async {
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(_key)))
        .getSingleOrNull();
    if (row != null) state = row.value == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: enabled ? 'true' : 'false'),
        );
  }
}

final leaderboardVisibilityControllerProvider =
    StateNotifierProvider<LeaderboardVisibilityController, bool>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LeaderboardVisibilityController(db);
});

/// Blueprint §3.2 Settings — "Extended time" UDL accommodation toggle for
/// timed activities. Informational for now: no Motion Lab/Evaluation
/// screen currently enforces a hard timer, so this doesn't change behavior
/// elsewhere in the app yet — it lets a teacher record the accommodation
/// ahead of any future timed feature that would need to read it.
class ExtendedTimeController extends StateNotifier<bool> {
  final AppDatabase db;

  ExtendedTimeController(this.db) : super(false) {
    _load();
  }

  static const _key = 'settings:extended_time';

  Future<void> _load() async {
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(_key)))
        .getSingleOrNull();
    if (row != null) state = row.value == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: enabled ? 'true' : 'false'),
        );
  }
}

final extendedTimeControllerProvider = StateNotifierProvider<ExtendedTimeController, bool>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExtendedTimeController(db);
});

/// Blueprint §7 Step 8: shared by Motion Lab and Graph Visualizer — always
/// keeps only the most recent [SimpleGraphicsController.defaultTrialHistoryCap]
/// trials (or the tighter [SimpleGraphicsController.capWhenEnabled] under
/// Simple graphics), regardless of how many a session has accumulated.
/// Chart/list re-render cost scales with what's actually rendered, not with
/// total trials ever recorded.
List<MotionTrialRow> capTrialHistory(List<MotionTrialRow> trials, {required bool simpleGraphics}) {
  final cap = simpleGraphics
      ? SimpleGraphicsController.capWhenEnabled
      : SimpleGraphicsController.defaultTrialHistoryCap;
  if (trials.length <= cap) return trials;
  return trials.sublist(trials.length - cap);
}
