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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<TeamBloc>()
      ..add(LoadTeams())
      ..add(LoadTeamSummaries(selectedDate));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      context.read<TeamBloc>().add(LoadTeamSummaries(selectedDate));
    }
  }

  Future<void> _onRefresh() async {
    _loadData();
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

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Card(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      child: Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(AppTheme.paddingSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppTheme.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Summary for',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(selectedDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit_calendar,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
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
                              padding:
                                  const EdgeInsets.all(AppTheme.paddingMedium),
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
                                    textColor:
                                        Theme.of(context).colorScheme.error,
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
              ),
            ],
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

  String _formatDate(DateTime date) {
    // Check if date is today
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    // Check if date is yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    // Format other dates
    return '${date.day}/${date.month}/${date.year}';
  }
}
