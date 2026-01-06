import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../home/presentation/widgets/clock_ticks_painter.dart';
import '../domain/timer_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final TimerService _timerService;
  bool _isSettingTime = true;
  Duration _selectedDuration = const Duration(minutes: 5); // Default

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(
      onTick: () {
        if (mounted) setState(() {});
      },
      onComplete: () {
        if (mounted) {
          _showCompletionDialog();
          setState(() => _isSettingTime = true);
        }
      },
    );
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerService.setDuration(_selectedDuration);
    _timerService.start();
    setState(() {
      _isSettingTime = false;
    });
  }

  void _resetTimer() {
    _timerService.reset();
    setState(() {
      _isSettingTime = true;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Finished!'),
        content: const Text('Your countdown has ended.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isSettingTime) ...[
          const Text(
            'Set Duration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hms,
              initialTimerDuration: _selectedDuration,
              onTimerDurationChanged: (Duration newDuration) {
                _selectedDuration = newDuration;
              },
            ),
          ),
          const SizedBox(height: 40),
          _MinimalButton(
            label: 'Start Timer',
            isPrimary: true,
            onPressed: _startTimer,
          ),
        ] else ...[
          // Running View (Circular Progress)
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
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accent.withValues(alpha: 0.3),
                  ),
                ),
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CircularProgressIndicator(
                    value: _timerService.progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    color: AppTheme.primaryText,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  _timerService.formattedTime,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MinimalButton(label: 'Cancel', onPressed: _resetTimer),
              const SizedBox(width: 40),
              _MinimalButton(
                label: _timerService.isRunning ? 'Pause' : 'Resume',
                isPrimary: true,
                onPressed: _timerService.isRunning
                    ? _timerService.stop
                    : _timerService.start,
              ),
            ],
          ),
        ],
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
