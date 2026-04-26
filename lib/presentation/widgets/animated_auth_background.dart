import 'package:flutter/material.dart';

class AnimatedAuthBackground extends StatefulWidget {
  final Widget child;

  const AnimatedAuthBackground({super.key, required this.child});

  @override
  State<AnimatedAuthBackground> createState() => _AnimatedAuthBackgroundState();
}

class _AnimatedAuthBackgroundState extends State<AnimatedAuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;

            return Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF7E8CB),
                        const Color(0xFFE7EFE1),
                        const Color(0xFFF9F4EA),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: -70 + (50 * progress),
                  left: -40 + (60 * progress),
                  child: _GlowOrb(
                    size: width.clamp(280.0, 520.0) * 0.55,
                    colors: const [
                      Color(0x66C9A84C),
                      Color(0x33E6C77B),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
                Positioned(
                  top: (height * 0.18) - (40 * progress),
                  right: -90 + (50 * progress),
                  child: _GlowOrb(
                    size: width.clamp(280.0, 520.0) * 0.5,
                    colors: const [
                      Color(0x553B4A2A),
                      Color(0x22C9A84C),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -110 + (60 * progress),
                  left: (width * 0.12) + (30 * progress),
                  child: _GlowOrb(
                    size: width.clamp(280.0, 520.0) * 0.6,
                    colors: const [
                      Color(0x44A8C0A0),
                      Color(0x22FFFFFF),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.06),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _GlowOrb({required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.25),
              blurRadius: 90,
              spreadRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
