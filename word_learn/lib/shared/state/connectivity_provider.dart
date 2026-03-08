import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Session 19 — Connectivity monitoring.
///
/// Polls once on startup and re-checks every 15 seconds by attempting a
/// lightweight TCP connection to a reliable host (Cloudflare 1.1.1.1:80).
///
/// Why not `connectivity_plus`?  That package reports the *interface* type
/// (WiFi, cellular, etc.) but not actual internet reachability — a WiFi
/// connection to a captive portal still shows "connected". A real TCP probe
/// is more reliable and needs zero extra dependencies.
///
/// Usage:
///   final isOnline = ref.watch(connectivityProvider);
class ConnectivityNotifier extends Notifier<bool> {
  static const _pollInterval = Duration(seconds: 15);
  static const _probe = ('1.1.1.1', 80);
  static const _timeout = Duration(seconds: 5);

  Timer? _timer;

  @override
  bool build() {
    // Start polling immediately.
    _startPolling();
    ref.onDispose(_stopPolling);
    return true; // Optimistic initial state — updated on first probe.
  }

  void _startPolling() {
    _check(); // Immediate first check.
    _timer = Timer.periodic(_pollInterval, (_) => _check());
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _check() async {
    final online = await _probe();
    // Only trigger a rebuild if the value has changed.
    if (online != state) state = online;
  }

  Future<bool> _probe() async {
    try {
      final sock = await Socket.connect(
        _probe.$1,
        _probe.$2,
        timeout: _timeout,
      );
      sock.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Trigger an immediate re-check (e.g. after a sync failure).
  Future<void> recheck() => _check();
}

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(
  ConnectivityNotifier.new,
);
