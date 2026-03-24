import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

class ChartsDemoPage extends StatefulWidget {
  const ChartsDemoPage({super.key});

  @override
  State<ChartsDemoPage> createState() => _ChartsDemoPageState();
}

class _ChartsDemoPageState extends State<ChartsDemoPage> {
  int _chartType = 0;

  final _monthLabels = ['1月', '2月', '3月', '4月', '5月', '6月'];
  final _values = [8.0, 12.0, 6.0, 15.0, 10.0, 18.0];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Charts 图表',
      subtitle: '使用 fl_chart 绘制柱状图、折线图、饼图',
      conceptItems: const [
        'BarChart：柱状图，用 BarChartGroupData 定义每组数据',
        'LineChart：折线图，用 FlSpot 定义数据点',
        'PieChart：饼图，用 PieSectionData 定义扇区',
        'fl_chart：Flutter 声明式图表库，高度可定制',
      ],
      children: [
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('柱状图')),
            ButtonSegment(value: 1, label: Text('折线图')),
            ButtonSegment(value: 2, label: Text('饼图')),
          ],
          selected: {_chartType},
          onSelectionChanged: (v) => setState(() => _chartType = v.first),
        ),
        const SizedBox(height: 24),

        SizedBox(
          height: 300,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildChart(),
          ),
        ),

        const SectionTitle('月度数据'),
        ...List.generate(_values.length, (i) {
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: _getColor(i),
              child: Text('${i + 1}', style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            title: Text(_monthLabels[i]),
            trailing: Text('${_values[i].toInt()} 万', style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }),
      ],
    );
  }

  Widget _buildChart() {
    switch (_chartType) {
      case 0:
        return _buildBarChart();
      case 1:
        return _buildLineChart();
      case 2:
        return _buildPieChart();
      default:
        return _buildBarChart();
    }
  }

  Color _getColor(int index) {
    const colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    return colors[index % colors.length];
  }

  Widget _buildBarChart() {
    return BarChart(
      key: const ValueKey('bar'),
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barGroups: List.generate(_values.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: _values[i],
                color: _getColor(i),
                width: 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < _monthLabels.length) {
                  return Text(_monthLabels[idx], style: const TextStyle(fontSize: 11));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      key: const ValueKey('line'),
      LineChartData(
        minY: 0,
        maxY: 20,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(_values.length, (i) => FlSpot(i.toDouble(), _values[i])),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withValues(alpha: 0.15),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < _monthLabels.length) {
                  return Text(_monthLabels[idx], style: const TextStyle(fontSize: 11));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      key: const ValueKey('pie'),
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: List.generate(_values.length, (i) {
          return PieChartSectionData(
            value: _values[i],
            color: _getColor(i),
            title: _monthLabels[i],
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            radius: 80,
          );
        }),
      ),
    );
  }
}
