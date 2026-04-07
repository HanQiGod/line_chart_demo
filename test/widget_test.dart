import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:line_chart_demo/main.dart';

void main() {
  testWidgets('line chart demo renders key sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LineChartDemoApp());

    expect(find.text('折线图示例'), findsOneWidget);
    expect(find.text('上半年指标走势'), findsOneWidget);
    expect(find.text('点击折线节点可查看对应月份和数值。'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });
}
