import 'dart:async';

class StopwatchService {
  final Function() onTick;

  StopwatchService({required this.onTick});

  /// Menggunakan stopwatch native dart untuk akurasi waktu yang presisi
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  /// Mengembalikan waktu yang sudah diformat (MM:SS:MS)
  String get formattedTime {
    final elapsed = _stopwatch.elapsedMilliseconds;

    final minutes = (elapsed ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((elapsed % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = ((elapsed % 1000) ~/ 10).toString().padLeft(
      2,
      '0',
    ); // Ambil 2 digit pertama ms

    return '$minutes:$seconds:$milliseconds';
  }

  int get currentMillisecond => _stopwatch.elapsedMilliseconds;

  bool get isRunning => _stopwatch.isRunning;

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      // Update setiap 30ms agar milidetik terlihat berjalan halus
      _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        onTick();
      });
    }
  }

  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      onTick(); // Update final state
    }
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    onTick(); // Reset UI ke 00:00:00
  }

  void dispose() {
    _timer?.cancel();
  }
}
