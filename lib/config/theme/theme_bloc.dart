import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ThemeBloc — Manages light/dark/system theme switching.
///
/// SETUP in main.dart:
///   BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitEvent()))
///
/// USAGE in MaterialApp:
///   BlocBuilder<ThemeBloc, ThemeState>(
///     builder: (context, state) => MaterialApp(
///       themeMode: state.themeMode,
///       theme: AppTheme.light,
///       darkTheme: AppTheme.dark,
///     ),
///   )
///
/// TOGGLE in any widget:
///   context.read<ThemeBloc>().add(ThemeToggleEvent())
///   context.read<ThemeBloc>().add(ThemeSetEvent(ThemeMode.dark))
/// ─────────────────────────────────────────────────────────────────────────────

// ── Events ────────────────────────────────────────────────────────────────────
abstract class ThemeEvent {}

/// Load saved theme from SharedPreferences on app start
class ThemeInitEvent extends ThemeEvent {}

/// Toggle between light and dark (ignores system)
class ThemeToggleEvent extends ThemeEvent {}

/// Set a specific theme mode
class ThemeSetEvent extends ThemeEvent {
  final ThemeMode mode;
  ThemeSetEvent(this.mode);
}

// ── State ─────────────────────────────────────────────────────────────────────
class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);

  bool get isLight  => themeMode == ThemeMode.light;
  bool get isDark   => themeMode == ThemeMode.dark;
  bool get isSystem => themeMode == ThemeMode.system;

  ThemeState copyWith({ThemeMode? themeMode}) =>
      ThemeState(themeMode ?? this.themeMode);
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _prefKey = 'app_theme_mode';

  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<ThemeInitEvent>(_onInit);
    on<ThemeToggleEvent>(_onToggle);
    on<ThemeSetEvent>(_onSet);
  }

  Future<void> _onInit(ThemeInitEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'system';
    final mode = _fromString(saved);
    emit(ThemeState(mode));
  }

  Future<void> _onToggle(ThemeToggleEvent event, Emitter<ThemeState> emit) async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await _save(next);
    emit(ThemeState(next));
  }

  Future<void> _onSet(ThemeSetEvent event, Emitter<ThemeState> emit) async {
    await _save(event.mode);
    emit(ThemeState(event.mode));
  }

  Future<void> _save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _toString(mode));
  }

  static String _toString(ThemeMode mode) => switch (mode) {
    ThemeMode.light  => 'light',
    ThemeMode.dark   => 'dark',
    ThemeMode.system => 'system',
  };

  static ThemeMode _fromString(String value) => switch (value) {
    'light'  => ThemeMode.light,
    'dark'   => ThemeMode.dark,
    _        => ThemeMode.system,
  };
}
