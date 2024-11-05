import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/config/theme.dart';
import '../../../blocs/team/team_bloc.dart';

import 'team_details_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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

        return ListView.builder(
          itemCount: state.teams.length,
          itemBuilder: (context, index) {
            final team = state.teams[index];
            return Card(
              margin: const EdgeInsets.all(AppTheme.paddingSmall),
              child: ListTile(
                title: Text(
                  team.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  'Managers: ${team.managerIds.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamDetailsScreen(teamId: team.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
