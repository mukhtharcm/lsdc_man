import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/blocs/auth/auth_bloc.dart';
import 'package:lsdc_man/blocs/auth/auth_state.dart';
import '../../../blocs/daily_entry/daily_entry_bloc.dart';
import '../../../blocs/daily_entry/daily_entry_event.dart';
import '../../../blocs/daily_entry/daily_entry_state.dart';
import '../../../models/user_model.dart';
import '../../../config/theme.dart';
import '../../daily_entry/screens/daily_entry_form.dart';

class MemberDetailsScreen extends StatefulWidget {
  final User member;
  final String teamName;

  const MemberDetailsScreen({
    super.key,
    required this.member,
    required this.teamName,
  });

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadTodayEntry();
  }

  void _loadTodayEntry() {
    context.read<DailyEntryBloc>().add(
          LoadUserTodayEntry(widget.member.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.member.name ?? widget.member.email,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.teamName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final currentUser = state.user;
              if (currentUser?.role == UserRole.admin ||
                  (currentUser?.role == UserRole.teamManager &&
                      currentUser?.team == widget.member.team)) {
                return BlocBuilder<DailyEntryBloc, DailyEntryState>(
                  builder: (context, state) {
                    if (state.currentEntry != null) {
                      return IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _showDeleteConfirmation,
                      );
                    }
                    return const SizedBox();
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<DailyEntryBloc, DailyEntryState>(
        builder: (context, state) {
          if (state.status == DailyEntryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final todayEntry = state.currentEntry;

          if (todayEntry == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No entry for today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  ElevatedButton.icon(
                    onPressed: _showEntryForm,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Entry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'Today\'s Summary',
                  [
                    _buildInfoRow(
                        'Total Calendars', todayEntry.noOfCalendar.toString()),
                    _buildInfoRow('Sold', todayEntry.soldNo.toString()),
                    _buildInfoRow(
                      'Remaining',
                      todayEntry.balance.toInt().toString(),
                      isHighlighted: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                _buildSection(
                  'Collection Details',
                  [
                    _buildInfoRow('₹500 × ${todayEntry.d500}',
                        '₹${todayEntry.d500 * 500}'),
                    _buildInfoRow('₹200 × ${todayEntry.d200}',
                        '₹${todayEntry.d200 * 200}'),
                    _buildInfoRow('₹100 × ${todayEntry.d100}',
                        '₹${todayEntry.d100 * 100}'),
                    _buildInfoRow(
                        '₹50 × ${todayEntry.d50}', '₹${todayEntry.d50 * 50}'),
                    _buildInfoRow(
                        '₹20 × ${todayEntry.d20}', '₹${todayEntry.d20 * 20}'),
                    _buildInfoRow(
                        '₹10 × ${todayEntry.d10}', '₹${todayEntry.d10 * 10}'),
                    _buildInfoRow(
                        '₹5 × ${todayEntry.d5}', '₹${todayEntry.d5 * 5}'),
                    _buildInfoRow(
                        '₹2 × ${todayEntry.d2}', '₹${todayEntry.d2 * 2}'),
                    _buildInfoRow('₹1 × ${todayEntry.d1}', '₹${todayEntry.d1}'),
                    const Divider(height: AppTheme.paddingLarge),
                    _buildInfoRow(
                      'Total Collection',
                      '₹${todayEntry.calculateTotal()}',
                      isHighlighted: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                _buildSection(
                  'Other Details',
                  [
                    _buildInfoRow(
                        'Expense', '₹${todayEntry.expense.toStringAsFixed(2)}'),
                    _buildInfoRow(
                        'Batta', '₹${todayEntry.batta.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEntryForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyEntryForm(
          selectedUser: widget.member,
        ),
      ),
    ).then((_) => _loadTodayEntry()); // Reload after form submission
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              final entry = context.read<DailyEntryBloc>().state.currentEntry;
              if (entry != null) {
                context.read<DailyEntryBloc>().add(DeleteDailyEntry(entry.id));
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingSmall),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isHighlighted ? FontWeight.bold : null,
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
          ),
        ],
      ),
    );
  }
}
