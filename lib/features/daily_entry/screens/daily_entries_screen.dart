import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/config/theme.dart';
import '../../../blocs/daily_entry/daily_entry_bloc.dart';
import '../../../blocs/daily_entry/daily_entry_event.dart';
import '../../../blocs/daily_entry/daily_entry_state.dart';
import '../../../models/user_model.dart';
import '../../../models/daily_entry.dart';
import 'daily_entry_form.dart';

class DailyEntriesScreen extends StatefulWidget {
  final UserRole? userRole;
  final String? teamId;

  const DailyEntriesScreen({
    super.key,
    required this.userRole,
    this.teamId,
  });

  @override
  State<DailyEntriesScreen> createState() => _DailyEntriesScreenState();
}

class _DailyEntriesScreenState extends State<DailyEntriesScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    // Admin can see all entries, team managers see team entries, members see their own
    final teamId = widget.userRole == UserRole.admin ? null : widget.teamId;

    context.read<DailyEntryBloc>().add(LoadDailyEntries(
          teamId: teamId,
          fromDate: _fromDate,
          toDate: _toDate,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: BlocBuilder<DailyEntryBloc, DailyEntryState>(
              builder: (context, state) {
                if (state.status == DailyEntryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == DailyEntryStatus.failure) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state.entries.isEmpty) {
                  return const Center(child: Text('No entries found'));
                }

                return ListView.builder(
                  itemCount: state.entries.length,
                  itemBuilder: (context, index) {
                    final entry = state.entries[index];
                    return Card(
                      margin: const EdgeInsets.all(AppTheme.paddingSmall),
                      child: ListTile(
                        title: Text(
                          'Date: ${entry.date.toLocal().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calendars: ${entry.noOfCalendar}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Sold: ${entry.soldNo}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Balance: ${entry.balance}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        trailing: _buildEntryActions(entry.id),
                        onTap: () => _showEntryDetails(entry),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _canCreateEntry()
          ? FloatingActionButton(
              onPressed: () => _showEntryForm(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_fromDate == null
                  ? 'From Date'
                  : _fromDate!.toLocal().toString().split(' ')[0]),
              onPressed: () => _selectDate(context, true),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_toDate == null
                  ? 'To Date'
                  : _toDate!.toLocal().toString().split(' ')[0]),
              onPressed: () => _selectDate(context, false),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _loadEntries,
          ),
        ],
      ),
    );
  }

  Widget _buildEntryActions(String entryId) {
    if (!_canModifyEntries()) return const SizedBox();

    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        if (widget.userRole == UserRole.admin)
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          // Handle edit
        } else if (value == 'delete') {
          _deleteEntry(entryId);
        }
      },
    );
  }

  bool _canCreateEntry() {
    return widget.userRole == UserRole.admin ||
        widget.userRole == UserRole.teamManager;
  }

  bool _canModifyEntries() {
    return widget.userRole == UserRole.admin ||
        widget.userRole == UserRole.teamManager;
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      _loadEntries();
    }
  }

  void _deleteEntry(String id) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DailyEntryBloc>().add(DeleteDailyEntry(id));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(DailyEntry entry) {
    // TODO: Implement entry details view
  }

  void _showEntryForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DailyEntryForm(),
      ),
    );
  }
}
