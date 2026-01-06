import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/presentation/widgets/clock_ticks_painter.dart';
import '../domain/stopwatch_service.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late final StopwatchService _stopwatchService;

  @override
  void initState() {
    super.initState();
    _stopwatchService = StopwatchService(
      onTick: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _stopwatchService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress (0.0 to 1.0) for the current minute
    // We can get milliseconds from the formatted string or expose raw duration from service.
    // For now, let's parse or better yet, make service expose Duration.
    // But since I can't change service easily without context, I'll rely on visual only or hack it lightly.
    // Actually, I should update Service to expose elapsedMilliseconds public getter.
    // Service ALREADY exposes `formattedTime`. Let's assume we can get raw ms or add a getter.
    // Checking service code... it has `_stopwatch.elapsedMilliseconds` private.
    // I should probably update the SERVICE to expose get elapsedMilliseconds.
    // But for now, let's just implement the UI and I'll update the Service in the next step if needed.
    // WAIT, I wrote the service! I can check if I exposed it.
    // `formattedTime` uses `_stopwatch.elapsedMilliseconds`.
    // I will use a simple indefinite progress or just 0 for now if I don't have access.
    // better: I will update the service to expose `elapsedMilliseconds` to make the progress circle work properly.

    // However, to avoid context switching too much, I'll update the UI first assuming I HAVE the getter,
    // and then I will immediately update the Service.

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Clock Face
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Clock Ticks
              SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: ClockTicksPainter(color: Colors.grey.shade300),
                ),
              ),
              // Background Circle (Light Grey)
              Container(
                width: 250, // Reduced size to fit inside ticks
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accent.withValues(alpha: 0.3),
                ),
              ),
              // Progress Indicator
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: _stopwatchService.currentMillisecond % 60000 / 60000,
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  color: AppTheme.primaryText,
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Decoration Dots (Optional, mimicking the image)
              Positioned(
                top: 40,
                right: 60,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 80,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Digital Time
              Text(
                _stopwatchService.formattedTime,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                  fontSize: 50,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MinimalButton(label: 'Reset', onPressed: _stopwatchService.reset),
            const SizedBox(width: 40),
            _MinimalButton(
              label: _stopwatchService.isRunning ? 'Pause' : 'Start',
              isPrimary: true,
              onPressed: _stopwatchService.isRunning
                  ? _stopwatchService.pause
                  : _stopwatchService.start,
            ),
          ],
        ),
      ],
    );
  }
}

class _MinimalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _MinimalButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.black : AppTheme.accent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
