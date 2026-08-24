import 'dart:async';

import 'package:flutter/material.dart';

typedef RevealBuilder = Widget Function(BuildContext context, bool revealed);

/// Listens to a [ScrollController] and notifies descendant [ScrollReveal]s
/// whenever the scroll position changes, so they can re-check visibility.
final class ScrollRevealScope extends StatefulWidget {
  const ScrollRevealScope({
    super.key,
    required this.scrollController,
    required this.child,
  });

  final ScrollController scrollController;
  final Widget child;

  @override
  State<ScrollRevealScope> createState() => _ScrollRevealScopeState();
}

class _ScrollRevealScopeState extends State<ScrollRevealScope> {
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () => _tick.value++;
    widget.scrollController.addListener(_listener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    _tick.dispose();
    super.dispose();
  }

  final ValueNotifier<int> _tick = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return _ScrollTick(tick: _tick, child: widget.child);
  }
}

class _ScrollTick extends InheritedNotifier<ValueNotifier<int>> {
  const _ScrollTick({required ValueNotifier<int> tick, required super.child})
    : super(notifier: tick);
}

/// Fades + slides its content in the first time it enters the viewport.
///
/// With [builder], the reveal state is exposed so callers can drive their
/// own animations (e.g. a count-up) once visible.
final class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.builder,
    this.delay = Duration.zero,
  }) : child = null;

  const ScrollReveal.child({
    super.key,
    required Widget this.child,
    this.delay = Duration.zero,
  }) : builder = null;

  final Widget? child;
  final RevealBuilder? builder;
  final Duration delay;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _revealed = false;
  Timer? _timer;
  bool _checkScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleCheck());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registers the InheritedNotifier dependency; also re-checks on scroll.
    context.dependOnInheritedWidgetOfExactType<_ScrollTick>();
    _scheduleCheck();
  }

  void _scheduleCheck() {
    if (_revealed || !mounted || _checkScheduled) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!mounted || _revealed) return;
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) return;
      final double dy = box.localToGlobal(Offset.zero).dy;
      final double threshold = MediaQuery.sizeOf(context).height * 0.92;
      if (dy < threshold) {
        _timer?.cancel();
        _timer = Timer(widget.delay, () {
          if (mounted) setState(() => _revealed = true);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content =
        widget.builder?.call(context, _revealed) ??
        AnimatedOpacity(
          opacity: _revealed ? 1 : 0,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: _revealed ? Offset.zero : const Offset(0, 0.06),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            child: widget.child,
          ),
        );
    return content;
  }
}

/// Animated integer count-up that starts when it becomes visible.
final class CountUpText extends StatelessWidget {
  const CountUpText({
    super.key,
    required this.value,
    required this.revealed,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
  });

  final int value;
  final bool revealed;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: revealed ? value.toDouble() : 0),
      duration: revealed ? duration : Duration.zero,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Text('${animatedValue.round()}', style: style);
      },
    );
  }
}
