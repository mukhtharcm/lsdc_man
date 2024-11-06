import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/config/theme.dart';
import '../../../blocs/team/team_bloc.dart';

import 'team_details_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>()
      ..add(LoadTeams())
      ..add(LoadTeamSummaries());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        return Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: ListView.separated(
            itemCount: state.teams.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTheme.paddingSmall),
            itemBuilder: (context, index) {
              final team = state.teams[index];
              final summary = state.teamSummaries[team.id];

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.all(AppTheme.paddingMedium),
                      title: Text(
                        team.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        'Members Reported: ${summary?.entriesCount ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TeamDetailsScreen(teamId: team.id),
                          ),
                        );
                      },
                    ),
                    if (summary != null) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.paddingMedium),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              'Total Collection',
                              '₹${summary.totalCollection.toStringAsFixed(2)}',
                              isHighlighted: true,
                              iconData: Icons.account_balance_wallet,
                            ),
                            const SizedBox(height: AppTheme.paddingSmall),
                            _buildSummaryRow(
                              'Calendars Sold',
                              summary.totalSold.toString(),
                              iconData: Icons.calendar_today,
                            ),
                            const SizedBox(height: AppTheme.paddingSmall),
                            _buildSummaryRow(
                              'Average per Calendar',
                              '₹${summary.averagePerCalendar.toStringAsFixed(2)}',
                              iconData: Icons.trending_up,
                              isHighlighted: true,
                            ),
                            const SizedBox(height: AppTheme.paddingSmall),
                            _buildSummaryRow(
                              'Total Expenses',
                              '₹${(summary.totalExpense + summary.totalBatta).toStringAsFixed(2)}',
                              iconData: Icons.money_off,
                              textColor: Theme.of(context).colorScheme.error,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHighlighted = false,
    IconData? iconData,
    Color? textColor,
  }) {
    return Row(
      children: [
        if (iconData != null) ...[
          Icon(
            iconData,
            size: 20,
            color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.paddingSmall),
        ],
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor ??
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isHighlighted ? FontWeight.bold : null,
                color: textColor ??
                    (isHighlighted
                        ? Theme.of(context).colorScheme.primary
                        : null),
              ),
        ),
      ],
    );
  }
}
