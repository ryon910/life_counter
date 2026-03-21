import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// カウントアップアニメーション（プロトタイプのANコンポーネント再現）
class CountUpText extends StatefulWidget {
  const CountUpText({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 2500),
    required this.style,
  });

  final int target;
  final Duration duration;
  final TextStyle style;

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _formatter = NumberFormat('#,###', 'ja_JP');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    // easeOut cubic (1 - (1-t)^3) と同等
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = (_animation.value * widget.target).floor();
        return Text(
          _formatter.format(value),
          style: widget.style,
        );
      },
    );
  }
}
