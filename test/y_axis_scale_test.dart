import 'package:flutter_test/flutter_test.dart';
import 'package:line_chart_demo/chart/y_axis_scale.dart';

void main() {
  group('buildYAxisScale', () {
    test('会把最大值补齐到完整分段，避免顶部标签挤在一起', () {
      final YAxisScale scale = buildYAxisScale(
        values: const <int>[10, 25, 18, 42, 37, 61],
        splitCount: 5,
      );

      expect(scale.interval, 13);
      expect(scale.maxY, 65);
    });

    test('空数据或很小的数据时仍然保留基础刻度', () {
      final YAxisScale scale = buildYAxisScale(
        values: const <int>[],
        splitCount: 5,
      );

      expect(scale.interval, 1);
      expect(scale.maxY, 5);
    });

    test('非法分段数会抛错', () {
      expect(
        () => buildYAxisScale(values: const <int>[1, 2, 3], splitCount: 0),
        throwsArgumentError,
      );
    });
  });
}
