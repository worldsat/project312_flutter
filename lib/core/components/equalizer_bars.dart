import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated Equalizer bars for audio status telemetry (SoundWave Ultra).
class EqualizerBars extends StatefulWidget {
  final bool isAnimating;
  final Color barColor;
  final double barWidth;
  final double maxHeight;

  const EqualizerBars({
    super.key,
    this.isAnimating = true,
    this.barColor = AppColors.violetAurora,
    this.barWidth = 2.5,
    this.maxHeight = 16.0,
  });

  @override
  State<EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<EqualizerBars> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim1;
  late final Animation<double> _anim2;
  late final Animation<double> _anim3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _anim1 = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.75, curve: Curves.easeInOut)),
    );
    _anim2 = Tween<double>(begin: 0.85, end: 0.40).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)),
    );
    _anim3 = Tween<double>(begin: 0.40, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.9, curve: Curves.easeInOut)),
    );

    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EqualizerBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
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
      animation: _controller,
      builder: (context, child) {
        final f1 = widget.isAnimating ? _anim1.value : 0.4;
        final f2 = widget.isAnimating ? _anim2.value : 0.7;
        final f3 = widget.isAnimating ? _anim3.value : 0.5;

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(f1),
            const SizedBox(width: 2.5),
            _buildBar(f2),
            const SizedBox(width: 2.5),
            _buildBar(f3),
          ],
        );
      },
    );
  }

  Widget _buildBar(double factor) {
    return Container(
      width: widget.barWidth,
      height: widget.maxHeight * factor,
      decoration: BoxDecoration(
        color: widget.barColor,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
