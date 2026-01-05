import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedWaveform extends StatefulWidget {
  final bool isPlaying;

  const AnimatedWaveform({super.key, required this.isPlaying});

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform> {
  static const int barCount = 24;
  final Random _random = Random();
  late List<double> amplitudes;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    amplitudes = List.generate(barCount, (_) => 0.2);
    _start();
  }

  @override
  void didUpdateWidget(covariant AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && _timer == null) {
      _start();
    } else if (!widget.isPlaying) {
      _stop();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() {
        amplitudes = amplitudes.map((e) {
          final target = widget.isPlaying
              ? _random.nextDouble().clamp(0.2, 1.0)
              : 0.2;
          return e + (target - e) * 0.5; // smooth easing
        }).toList();
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      amplitudes = List.generate(barCount, (_) => 0.2);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: amplitudes.map((amp) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 4,
            height: 60 * amp,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
