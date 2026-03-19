import 'dart:async';

import 'package:flutter/material.dart';

/// Displays DD:HH:MM:SS countdown using Timer.periodic.
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endTime,
    this.style,
    this.onComplete,
  });

  final DateTime endTime;
  final TextStyle? style;
  final VoidCallback? onComplete;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    if (widget.endTime.isAfter(now)) {
      setState(() {
        _remaining = widget.endTime.difference(now);
      });
    } else {
      _timer?.cancel();
      widget.onComplete?.call();
      setState(() => _remaining = Duration.zero);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Text(
      '${_pad(days)}:${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}',
      style: widget.style ??
          Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
    );
  }
}
