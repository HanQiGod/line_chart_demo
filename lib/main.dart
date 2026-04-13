import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'chart/y_axis_scale.dart';

void main() {
  runApp(const LineChartDemoApp());
}

class LineChartDemoApp extends StatelessWidget {
  const LineChartDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '折线图示例',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F6CBD),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF0F172A),
          elevation: 0,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: const LineChartSample(),
    );
  }
}

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  static const int _yAxisSplitCount = 5;

  static const List<_MonthlyValue> _monthlyValues = <_MonthlyValue>[
    _MonthlyValue(x: 0, month: 'Jan', value: 10),
    _MonthlyValue(x: 1, month: 'Feb', value: 25),
    _MonthlyValue(x: 2, month: 'Mar', value: 18),
    _MonthlyValue(x: 3, month: 'Apr', value: 42),
    _MonthlyValue(x: 4, month: 'May', value: 37),
    _MonthlyValue(x: 5, month: 'Jun', value: 58),
  ];

  List<FlSpot> get _spots => _monthlyValues
      .map((item) => FlSpot(item.x, item.value.toDouble()))
      .toList(growable: false);

  int get _total =>
      _monthlyValues.fold<int>(0, (sum, item) => sum + item.value);

  double get _average => _total / _monthlyValues.length;

  YAxisScale get _yAxisScale => buildYAxisScale(
    values: _monthlyValues.map((item) => item.value),
    splitCount: _yAxisSplitCount,
  );

  _MonthlyValue get _highestPoint => _monthlyValues.reduce(
    (current, next) => current.value >= next.value ? current : next,
  );

  _MonthlyValue get _lowestPoint => _monthlyValues.reduce(
    (current, next) => current.value <= next.value ? current : next,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('折线图示例')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF0F6CBD), Color(0xFF22C1C3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x220F6CBD),
                    blurRadius: 24,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '基于文章示例的 fl_chart 折线图 Demo',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '保留了坐标轴、网格线、边框、曲线、圆点、面积填充和触摸提示，另外补了一层页面包装，方便你直接运行演示。',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.touch_app_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '点击折线节点可查看对应月份和数值。',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x120F172A),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '上半年指标走势',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '示例数据从 1 月到 6 月逐步上升，4 月和 6 月是两个明显高点。',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF475569),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: LineChart(
                      _buildChartData(theme),
                      duration: const Duration(milliseconds: 250),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _MetricCard(
                  label: '最高值',
                  value: '${_highestPoint.value}',
                  hint: '${_highestPoint.month} 达到峰值',
                  icon: Icons.north_east_rounded,
                  color: const Color(0xFF0F6CBD),
                ),
                _MetricCard(
                  label: '最低值',
                  value: '${_lowestPoint.value}',
                  hint: '${_lowestPoint.month} 为起点',
                  icon: Icons.south_west_rounded,
                  color: const Color(0xFF0F766E),
                ),
                _MetricCard(
                  label: '平均值',
                  value: _average.toStringAsFixed(1),
                  hint: '6 个月平均水平',
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF7C3AED),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(ThemeData theme) {
    final YAxisScale yAxisScale = _yAxisScale;

    return LineChartData(
      minX: 0,
      maxX: _monthlyValues.length - 1,
      minY: 0,
      maxY: yAxisScale.maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: yAxisScale.interval,
        getDrawingHorizontalLine: (double value) {
          return FlLine(
            color: const Color(0xFFE2E8F0),
            strokeWidth: 1,
            dashArray: <int>[6, 4],
          );
        },
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: yAxisScale.interval,
            reservedSize: 42,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 34,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xFFD7E0EA)),
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: _spots,
          isCurved: true,
          curveSmoothness: 0.28,
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF0F6CBD), Color(0xFF22C1C3)],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 4.5,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: const Color(0xFF0F6CBD),
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color(0xFF0F6CBD).withValues(alpha: 0.24),
                const Color(0xFF22C1C3).withValues(alpha: 0.05),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes
                  .map((int index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: const Color(0xFF0F6CBD).withValues(alpha: 0.3),
                        strokeWidth: 2,
                        dashArray: <int>[4, 4],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, spotIndex) =>
                            FlDotCirclePainter(
                              radius: 6,
                              color: const Color(0xFF0F6CBD),
                              strokeWidth: 3,
                              strokeColor: Colors.white,
                            ),
                      ),
                    );
                  })
                  .toList(growable: false);
            },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => const Color(0xFF0F172A),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipBorderRadius: BorderRadius.circular(16),
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots
                .map((LineBarSpot spot) {
                  final _MonthlyValue current = _monthlyValues[spot.x.toInt()];
                  return LineTooltipItem(
                    '${current.month}\n',
                    const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${current.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const TextSpan(
                        text: ' 单位',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                })
                .toList(growable: false);
          },
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int index = value.toInt();
    final String text = index >= 0 && index < _monthlyValues.length
        ? _monthlyValues[index].month
        : '';

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String hint;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 172,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF94A3B8),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyValue {
  const _MonthlyValue({
    required this.x,
    required this.month,
    required this.value,
  });

  final double x;
  final String month;
  final int value;
}
