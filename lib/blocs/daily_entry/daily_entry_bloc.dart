import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/daily_entry_repository.dart';
import 'daily_entry_event.dart';
import 'daily_entry_state.dart';

class DailyEntryBloc extends Bloc<DailyEntryEvent, DailyEntryState> {
  final DailyEntryRepository _dailyEntryRepository;

  DailyEntryBloc({
    required DailyEntryRepository dailyEntryRepository,
  })  : _dailyEntryRepository = dailyEntryRepository,
        super(const DailyEntryState()) {
    on<LoadDailyEntries>(_onLoadDailyEntries);
    on<LoadUserTodayEntry>(_onLoadUserTodayEntry);
    on<CreateDailyEntry>(_onCreateDailyEntry);
    on<UpdateDailyEntry>(_onUpdateDailyEntry);
    on<DeleteDailyEntry>(_onDeleteDailyEntry);
    on<CheckDailyEntryExists>(_onCheckDailyEntryExists);
  }

  Future<void> _onLoadDailyEntries(
    LoadDailyEntries event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(const DailyEntryState(status: DailyEntryStatus.loading));
    try {
      final entries = await _dailyEntryRepository.getEntries(
        teamId: event.teamId,
        userId: event.userId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(DailyEntryState(
        status: DailyEntryStatus.success,
        entries: entries,
      ));
    } catch (e) {
      emit(DailyEntryState(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadUserTodayEntry(
    LoadUserTodayEntry event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(const DailyEntryState(status: DailyEntryStatus.loading));
    try {
      final entry =
          await _dailyEntryRepository.getTodayEntryForUser(event.userId);
      if (entry != null) {
        emit(DailyEntryState(
          status: DailyEntryStatus.success,
          currentEntry: entry,
        ));
      } else {
        emit(const DailyEntryState(status: DailyEntryStatus.success));
      }
    } catch (e) {
      emit(DailyEntryState(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreateDailyEntry(
    CreateDailyEntry event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(state.copyWith(status: DailyEntryStatus.loading));
    try {
      final entry = await _dailyEntryRepository.createEntry(event.entry);
      emit(state.copyWith(
        status: DailyEntryStatus.success,
        entries: [...state.entries, entry],
        currentEntry: entry,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateDailyEntry(
    UpdateDailyEntry event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(state.copyWith(status: DailyEntryStatus.loading));
    try {
      final entry = await _dailyEntryRepository.updateEntry(
        event.id,
        event.entry,
      );
      final updatedEntries = state.entries.map((e) {
        return e.id == event.id ? entry : e;
      }).toList();
      emit(state.copyWith(
        status: DailyEntryStatus.success,
        entries: updatedEntries,
        currentEntry: entry,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteDailyEntry(
    DeleteDailyEntry event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(state.copyWith(status: DailyEntryStatus.loading));
    try {
      await _dailyEntryRepository.deleteEntry(event.id);
      final updatedEntries =
          state.entries.where((e) => e.id != event.id).toList();
      emit(state.copyWith(
        status: DailyEntryStatus.success,
        entries: updatedEntries,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCheckDailyEntryExists(
    CheckDailyEntryExists event,
    Emitter<DailyEntryState> emit,
  ) async {
    emit(state.copyWith(status: DailyEntryStatus.loading));
    try {
      final entry = await _dailyEntryRepository.getEntryForDate(
        event.teamId,
        event.date,
      );
      emit(state.copyWith(
        status: DailyEntryStatus.success,
        currentEntry: entry,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DailyEntryStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
