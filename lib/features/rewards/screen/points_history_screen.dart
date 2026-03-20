import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Points History')),
      body: BlocBuilder<RewardBloc, RewardState>(
        builder: (context, state) {
          if (state is RewardLoaded) {
            return _PointsHistoryBody(
              history: state.history,
              chartData: state.chartData,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PointsHistoryBody extends StatelessWidget {
  const _PointsHistoryBody({
    required this.history,
    required this.chartData,
  });

  final List<PointsTransaction> history;
  final List<DailyPointsData> chartData;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 30 Days',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: _PointsChart(data: chartData),
          ),
          const SizedBox(height: 24),
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = history[index];
              return _PointsHistoryTile(
                transaction: tx,
                colors: colors,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PointsChart extends StatelessWidget {
  const _PointsChart({required this.data});

  final List<DailyPointsData> data;

  @override
  Widget build(BuildContext context) {
    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.pointsEarned.toDouble())).toList();
    final maxY = data.isEmpty ? 1.0 : (data.map((d) => d.pointsEarned).reduce((a, b) => a > b ? a : b) + 20).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i % 7 == 0 && i >= 0 && i < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('d/M').format(data[i].date),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 28,
              interval: 7,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: spots.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.y,
                color: Theme.of(context).colorScheme.primary,
                width: 4,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
            showingTooltipIndicators: [],
          );
        }).toList(),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _PointsHistoryTile extends StatelessWidget {
  const _PointsHistoryTile({
    required this.transaction,
    required this.colors,
  });

  final PointsTransaction transaction;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final isEarn = transaction.type == TransactionType.earn;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEarn ? colors.pointsContainer : colors.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isEarn ? Icons.monetization_on : Icons.card_giftcard,
          color: isEarn ? colors.points : colors.error,
          size: 24,
        ),
      ),
      title: Text(transaction.description),
      subtitle: Text(
        DateFormat('MMM d, y • HH:mm').format(transaction.date),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.points >= 0 ? '+' : ''}${transaction.points}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isEarn ? colors.points : colors.error,
            ),
          ),
          Text(
            'Bal: ${transaction.runningBalance}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
