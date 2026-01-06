import 'dart:async';

class TimerService {
  final Function() onTick;
  final Function() onComplete;

  TimerService({required this.onTick, required this.onComplete});

  Timer? _timer;
  Duration _initialDuration = Duration.zero;
  Duration _remainingDuration = Duration.zero;

  bool get isRunning => _timer?.isActive ?? false;

  // Progress 0.0 (Empty) to 1.0 (Full)
  double get progress {
    if (_initialDuration.inMilliseconds == 0) return 0.0;
    return _remainingDuration.inMilliseconds / _initialDuration.inMilliseconds;
  }

  String get formattedTime {
    final hours = _remainingDuration.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingDuration.inMinutes % 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_remainingDuration.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    return '$hours:$minutes:$seconds';
  }

  void setDuration(Duration duration) {
    _initialDuration = duration;
    _remainingDuration = duration;
    onTick();
  }

  void start() {
    if (_remainingDuration.inSeconds == 0) return;

    if (!isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingDuration.inSeconds > 0) {
          _remainingDuration -= const Duration(seconds: 1);
          onTick();
        } else {
          stop();
          onComplete();
        }
      });
    }
  }

  void stop() {
    _timer?.cancel();
    onTick();
  }

  void reset() {
    stop();
    _remainingDuration = _initialDuration;
    onTick();
  }

  void dispose() {
    stop();
  }
}
