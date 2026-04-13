import 'dart:math' as math;

class YAxisScale {
  const YAxisScale({required this.maxY, required this.interval});

  final double maxY;
  final double interval;
}

YAxisScale buildYAxisScale({
  required Iterable<num> values,
  int splitCount = 5,
  double minInterval = 1,
}) {
  if (splitCount <= 0) {
    throw ArgumentError.value(splitCount, 'splitCount', '必须大于 0');
  }

  final double maxValue = values.fold<double>(
    0,
    (double currentMax, num value) => math.max(currentMax, value.toDouble()),
  );
  final double interval = math.max(
    (maxValue / splitCount).ceilToDouble(),
    minInterval,
  );

  return YAxisScale(maxY: interval * splitCount, interval: interval);
}
