import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/team.dart';
import '../../models/team_summary.dart';
import '../../repositories/team_repository.dart';

// Events
abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeams extends TeamEvent {}

class LoadTeamDetails extends TeamEvent {
  final String teamId;

  LoadTeamDetails(this.teamId);

  @override
  List<Object?> get props => [teamId];
}

class LoadTeamSummaries extends TeamEvent {
  final DateTime date;

  LoadTeamSummaries(this.date);

  @override
  List<Object?> get props => [date];
}

// States
class TeamState extends Equatable {
  final List<Team> teams;
  final Team? selectedTeam;
  final Map<String, TeamSummary> teamSummaries;
  final bool isLoading;
  final String? error;

  const TeamState({
    this.teams = const [],
    this.selectedTeam,
    this.teamSummaries = const {},
    this.isLoading = false,
    this.error,
  });

  TeamState copyWith({
    List<Team>? teams,
    Team? selectedTeam,
    Map<String, TeamSummary>? teamSummaries,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      teamSummaries: teamSummaries ?? this.teamSummaries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [teams, selectedTeam, teamSummaries, isLoading, error];
}

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;
  UnsubscribeFunc? _entriesUnsubscribe;
  UnsubscribeFunc? _teamsUnsubscribe;
  DateTime? _currentDate;

  TeamBloc({required TeamRepository teamRepository})
      : _teamRepository = teamRepository,
        super(const TeamState()) {
    on<LoadTeams>(_onLoadTeams);
    on<LoadTeamDetails>(_onLoadTeamDetails);
    on<LoadTeamSummaries>(_onLoadTeamSummaries);
  }

  Future<void> _onLoadTeams(LoadTeams event, Emitter<TeamState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final teams = await _teamRepository.getTeams();
      emit(state.copyWith(
        teams: teams,
        isLoading: false,
      ));

      // Subscribe to teams collection changes
      _teamsUnsubscribe?.call();
      _teamsUnsubscribe =
          await _teamRepository.pb.collection('teams').subscribe('*', (e) {
        // Instead of directly adding event, trigger a reload
        _reloadTeams();
      });
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadTeamSummaries(
    LoadTeamSummaries event,
    Emitter<TeamState> emit,
  ) async {
    try {
      _currentDate = event.date;
      final summaries =
          await _teamRepository.getTeamsSummaryForToday(event.date);
      emit(state.copyWith(teamSummaries: summaries));

      // Cancel existing subscription if any
      await _entriesUnsubscribe?.call();

      // Subscribe to dairy_entries collection changes
      _entriesUnsubscribe = await _teamRepository.pb
          .collection('dairy_entries')
          .subscribe('*', (e) {
        // Instead of directly emitting, trigger a reload
        if (_currentDate != null) {
          add(LoadTeamSummaries(_currentDate!));
        }
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Helper method to reload teams
  void _reloadTeams() {
    add(LoadTeams());
  }

  Future<void> _onLoadTeamDetails(
      LoadTeamDetails event, Emitter<TeamState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final team = await _teamRepository.getTeamWithMembers(event.teamId);
      emit(state.copyWith(
        selectedTeam: team,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    await _entriesUnsubscribe?.call();
    await _teamsUnsubscribe?.call();
    return super.close();
  }
}
