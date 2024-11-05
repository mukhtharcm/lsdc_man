import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (widget.member.teamId != null) {
      context.read<DailyEntryBloc>().add(
            LoadDailyEntries(
              teamId: widget.member.teamId,
              fromDate: DateTime.now(),
              toDate: DateTime.now(),
            ),
          );
    }
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
      ),
      body: BlocBuilder<DailyEntryBloc, DailyEntryState>(
        builder: (context, state) {
          if (state.status == DailyEntryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final todayEntry = state.entries.isEmpty ? null : state.entries.first;

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
                        'Calendars', todayEntry.noOfCalendar.toString()),
                    _buildInfoRow('Sold', todayEntry.soldNo.toString()),
                    _buildInfoRow(
                        'Balance', '₹${todayEntry.balance.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                _buildSection(
                  'Denominations',
                  [
                    _buildInfoRow('₹500', todayEntry.d500.toString()),
                    _buildInfoRow('₹200', todayEntry.d200.toString()),
                    _buildInfoRow('₹100', todayEntry.d100.toString()),
                    _buildInfoRow('₹50', todayEntry.d50.toString()),
                    _buildInfoRow('₹20', todayEntry.d20.toString()),
                    _buildInfoRow('₹10', todayEntry.d10.toString()),
                    _buildInfoRow('₹5', todayEntry.d5.toString()),
                    _buildInfoRow('₹2', todayEntry.d2.toString()),
                    _buildInfoRow('₹1', todayEntry.d1.toString()),
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
        builder: (context) => const DailyEntryForm(),
      ),
    ).then((_) => _loadTodayEntry()); // Reload after form submission
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

  Widget _buildInfoRow(String label, String value) {
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
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
