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

        return Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: ListView.separated(
            itemCount: state.teams.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTheme.paddingSmall),
            itemBuilder: (context, index) {
              final team = state.teams[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      team.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: AppTheme.paddingSmall),
                      child: Text(
                        'Managers: ${team.managerIds.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
