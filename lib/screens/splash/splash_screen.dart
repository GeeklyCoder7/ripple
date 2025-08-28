import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ripple/core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

class SplashWavesMoving extends StatefulWidget {
  const SplashWavesMoving({super.key});
  @override
  State<SplashWavesMoving> createState() => _SplashWavesMovingState();
}

class _SplashWavesMovingState extends State<SplashWavesMoving>
    with TickerProviderStateMixin {
  late final AnimationController _waveCtrl;
  late final AnimationController _receiverGlowCtrl;
  late final AnimationController _iconsCtrl;
  late final AnimationController _titleCtrl;

  bool _hasNavigated = false;

  static const double leftCenterX = 0.12;
  static const double rightCenterX = 0.88;
  static const double deviceWidthFactor = 0.13;

  @override
  void initState() {
    super.initState();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _receiverGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _iconsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start title animation earlier at 0.8 seconds
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _titleCtrl.forward();
    });

    // Navigate after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && !_hasNavigated) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(
          milliseconds: 800,
        ), // Slightly longer for bounce effect
        reverseTransitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut, // This creates the bouncy pop effect
          );

          // Scale animation for pop effect
          final scaleAnimation = Tween<double>(
            begin: 0.0, // Start very small
            end: 1.0, // End at normal size
          ).animate(curved);

          // Fade animation for smooth appearance
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _receiverGlowCtrl.dispose();
    _iconsCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepOcean,
      body: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _waveCtrl,
            _receiverGlowCtrl,
            _iconsCtrl,
            _titleCtrl,
          ]),
          builder: (_, __) {
            final phase = _waveCtrl.value * 2 * math.pi;
            final slide =
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
                );
            final fade = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: _titleCtrl, curve: Curves.easeIn),
            );

            return Stack(
              fit: StackFit.expand,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.deepOcean, AppColors.waveBlue],
                    ),
                  ),
                ),
                CustomPaint(
                  painter: MultiWavePainter(phase: phase, shadowOpacity: 0.06),
                ),
                CustomPaint(
                  painter: DevicesPainter(
                    glow: _receiverGlowCtrl.value,
                    leftCenterX: leftCenterX,
                    rightCenterX: rightCenterX,
                    deviceWidthFactor: deviceWidthFactor,
                  ),
                ),
                CustomPaint(
                  painter: IconsAlongWavePainter(
                    phase: -(phase * 0.9 + 0.8),
                    progress: _iconsCtrl.value,
                    leftDeviceCenterXFactor: leftCenterX,
                    rightDeviceCenterXFactor: rightCenterX,
                    deviceWidthFactor: deviceWidthFactor,
                    iconSets: const [
                      IconSpec(
                        icon: Icons.insert_drive_file_rounded,
                        color: AppColors.white,
                      ),
                      IconSpec(
                        icon: Icons.image_rounded,
                        color: AppColors.foamBlue,
                      ),
                      IconSpec(
                        icon: Icons.videocam_rounded,
                        color: AppColors.white,
                      ),
                      IconSpec(
                        icon: Icons.music_note_rounded,
                        color: AppColors.foamBlue,
                      ),
                      IconSpec(
                        icon: Icons.android_rounded,
                        color: AppColors.white,
                      ),
                    ],
                    count: 8,
                  ),
                ),
                SlideTransition(
                  position: slide,
                  child: FadeTransition(
                    opacity: fade,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppConstants.appDescription,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MultiWavePainter extends CustomPainter {
  final double phase;
  final double shadowOpacity;
  const MultiWavePainter({required this.phase, required this.shadowOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.5;
    _drawLayer(
      canvas,
      size,
      centerY,
      0.05,
      1.2,
      2.4,
      phase * -0.6,
      AppColors.waveBlue.withOpacity(0.65),
      AppColors.surfBlue.withOpacity(0.65),
      12,
    );
    _drawLayer(
      canvas,
      size,
      centerY,
      0.06,
      1.5,
      3.0,
      phase * -0.9 - 0.8,
      AppColors.waveBlue.withOpacity(0.9),
      AppColors.surfBlue.withOpacity(0.9),
      0,
    );
    _drawLayer(
      canvas,
      size,
      centerY,
      0.045,
      1.9,
      2.0,
      phase * -1.3 - 1.6,
      AppColors.cyanSplash.withOpacity(0.85),
      AppColors.aquaMist.withOpacity(0.85),
      -10,
    );
  }

  void _drawLayer(
    Canvas canvas,
    Size size,
    double cy,
    double af,
    double freq,
    double sw,
    double ph,
    Color a,
    Color b,
    double yOff,
  ) {
    final amp = math.max(12.0, size.height * af);
    final by = cy + yOff;
    final path = _buildPath(size.width, by, amp, freq, ph);

    final shadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw + 1.2
      ..color = Colors.black.withOpacity(shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final shader = LinearGradient(
      colors: [a, b],
    ).createShader(Rect.fromLTWH(0, by - amp * 2, size.width, amp * 4));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..shader = shader
      ..isAntiAlias = true;

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, paint);
  }

  Path _buildPath(double w, double by, double amp, double freq, double ph) {
    final p = Path();
    const int samples = 160;
    final dx = w / (samples - 1);
    double x0 = 0, y0 = by + math.sin(ph) * amp;
    p.moveTo(x0, y0);
    for (int i = 1; i < samples; i++) {
      final x = i * dx;
      final y = by + math.sin((i / samples) * 2 * math.pi * freq + ph) * amp;
      p.quadraticBezierTo(x0, y0, (x0 + x) * 0.5, (y0 + y) * 0.5);
      x0 = x;
      y0 = y;
    }
    p.lineTo(w, y0);
    return p;
  }

  @override
  bool shouldRepaint(covariant MultiWavePainter old) => true;
}

class DevicesPainter extends CustomPainter {
  final double glow;
  final double leftCenterX;
  final double rightCenterX;
  final double deviceWidthFactor;

  const DevicesPainter({
    required this.glow,
    required this.leftCenterX,
    required this.rightCenterX,
    required this.deviceWidthFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height * 0.5;
    final w = math.max(72.0, size.width * deviceWidthFactor);
    final h = w * 1.9;

    final left = Rect.fromCenter(
      center: Offset(size.width * leftCenterX, cy),
      width: w,
      height: h,
    );
    final right = Rect.fromCenter(
      center: Offset(size.width * rightCenterX, cy),
      width: w,
      height: h,
    );

    _drawDevice(canvas, left, isReceiver: false, glow: 0);
    _drawDevice(canvas, right, isReceiver: true, glow: glow);
  }

  void _drawDevice(
    Canvas canvas,
    Rect rect, {
    required bool isReceiver,
    required double glow,
  }) {
    if (isReceiver && glow > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.inflate(16 + 20 * glow),
          const Radius.circular(24),
        ),
        Paint()
          ..color = AppColors.cyanSplash.withOpacity(0.18 + 0.12 * (1 - glow))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
      );
    }

    final body = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isReceiver
            ? [
                AppColors.cyanSplash.withOpacity(0.30),
                AppColors.tealWave.withOpacity(0.25),
              ]
            : [
                AppColors.foamBlue.withOpacity(0.30),
                AppColors.surfBlue.withOpacity(0.20),
              ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final outline = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..isAntiAlias = true;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      outline,
    );

    final sr = rect.deflate(rect.width * 0.08);
    canvas.drawRRect(
      RRect.fromRectAndRadius(sr, const Radius.circular(16)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isReceiver
              ? [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.06)]
              : [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.07),
                ],
        ).createShader(sr),
    );

    final notch = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(rect.center.dx, rect.top + rect.height * 0.034 * 1.6),
        width: rect.width * 0.28,
        height: rect.height * 0.034,
      ),
      const Radius.circular(9),
    );
    canvas.drawRRect(notch, Paint()..color = Colors.white.withOpacity(0.55));

    final iconSize = rect.width * 0.18;
    final iconOffset = Offset(rect.center.dx, rect.center.dy);
    final iconData = isReceiver ? Icons.download_rounded : Icons.send_rounded;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: iconOffset,
          width: iconSize * 1.15,
          height: iconSize * 1.15,
        ),
        const Radius.circular(12),
      ),
      Paint()..color = Colors.white.withOpacity(isReceiver ? 0.92 : 0.85),
    );

    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: isReceiver ? AppColors.cyanSplash : AppColors.waveBlue,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, iconOffset - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant DevicesPainter old) => true;
}

class IconsAlongWavePainter extends CustomPainter {
  final double phase;
  final double progress;
  final double leftDeviceCenterXFactor;
  final double rightDeviceCenterXFactor;
  final double deviceWidthFactor;
  final List<IconSpec> iconSets;
  final int count;

  const IconsAlongWavePainter({
    required this.phase,
    required this.progress,
    required this.leftDeviceCenterXFactor,
    required this.rightDeviceCenterXFactor,
    required this.deviceWidthFactor,
    required this.iconSets,
    required this.count,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height * 0.5;
    final amp = math.max(12.0, size.height * 0.06);
    final dw = math.max(72.0, size.width * deviceWidthFactor);
    final startX = size.width * leftDeviceCenterXFactor + dw / 2 + 10;
    final endX = size.width * rightDeviceCenterXFactor - dw / 2 - 10;
    final span = (endX - startX).clamp(0.0, size.width);
    if (span <= 0) return;
    for (int i = 0; i < count; i++) {
      final spec = iconSets[i % iconSets.length];
      double t = (progress + i / count) % 1.0;
      t = Curves.easeInOut.transform(t);
      final x = startX + span * t;
      final y =
          cy + math.sin(2 * math.pi * 1.5 * (x / size.width) + phase) * amp;
      final bob = math.sin((t * 2 * math.pi) + (x * 0.02)) * (amp * 0.1);
      final fadeIn = (t < 0.15) ? (t / 0.15) : 1.0;
      final fadeOut = (t > 0.85) ? ((1 - t) / 0.15) : 1.0;
      final alpha = (fadeIn * fadeOut).clamp(0.0, 1.0);
      final sizeIcon = 20 * (0.75 + 0.25 * alpha);
      final tp = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(spec.icon.codePoint),
          style: TextStyle(
            fontSize: sizeIcon,
            fontFamily: spec.icon.fontFamily,
            package: spec.icon.fontPackage,
            color: spec.color.withOpacity(alpha),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y + bob - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant IconsAlongWavePainter old) => true;
}

class IconSpec {
  final IconData icon;
  final Color color;
  const IconSpec({required this.icon, required this.color});
}
