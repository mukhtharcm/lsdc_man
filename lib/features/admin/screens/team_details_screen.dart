import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/blocs/daily_entry/daily_entry_event.dart';
import 'package:lsdc_man/blocs/daily_entry/daily_entry_state.dart';
import '../../../blocs/daily_entry/daily_entry_bloc.dart';
import '../../../blocs/team/team_bloc.dart';
import '../../../models/user_model.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;

  const TeamDetailsScreen({super.key, required this.teamId});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(LoadTeamDetails(widget.teamId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Details')),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final team = state.selectedTeam;
          if (team == null) return const Center(child: Text('Team not found'));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  team.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: team.members?.length ?? 0,
                  itemBuilder: (context, index) {
                    final member = team.members![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        title: Text(member.name ?? member.email),
                        subtitle: Text(member.role?.toString() ?? 'No role'),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _showMemberDetails(member),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMemberDetails(User member) {
    // Load today's entry for this member
    context.read<DailyEntryBloc>().add(
          LoadDailyEntries(
            teamId: widget.teamId,
            fromDate: DateTime.now(),
            toDate: DateTime.now(),
          ),
        );

    // Show bottom sheet with member details
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<DailyEntryBloc, DailyEntryState>(
        builder: (context, state) {
          if (state.status == DailyEntryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final todayEntry = state.entries.isEmpty ? null : state.entries.first;

          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  member.name ?? member.email,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (todayEntry != null) ...[
                  const Text('Today\'s Entry:'),
                  Text('Calendars: ${todayEntry.noOfCalendar}'),
                  Text('Sold: ${todayEntry.soldNo}'),
                  Text('Balance: ${todayEntry.balance}'),
                ] else
                  const Text('No entry for today'),
              ],
            ),
          );
        },
      ),
    );
  }
}
