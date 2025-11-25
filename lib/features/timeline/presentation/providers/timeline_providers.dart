import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/timeline_local_datasource.dart';
import '../../data/repositories/timeline_repository_impl.dart';
import '../../domain/entities/timeline.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../../domain/usecases/get_timelines.dart';
import '../../domain/usecases/get_timeline.dart';
import '../../domain/usecases/create_timeline.dart';
import '../../domain/usecases/update_timeline.dart';
import '../../domain/usecases/delete_timeline.dart';
import '../../domain/usecases/add_event_to_timeline.dart';
import '../../domain/usecases/update_event_in_timeline.dart';
import '../../domain/usecases/delete_event_from_timeline.dart';
import '../../../../core/usecases/usecase.dart';
import 'timeline_state.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider for local data source
final timelineLocalDataSourceProvider = Provider<TimelineLocalDataSource>((ref) {
  return TimelineLocalDataSourceImpl();
});

// ============================================================================
// Repository Providers
// ============================================================================

/// Provider for timeline repository
final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  final localDataSource = ref.watch(timelineLocalDataSourceProvider);
  return TimelineRepositoryImpl(localDataSource: localDataSource);
});

// ============================================================================
// Use Case Providers
// ============================================================================

final getTimelinesUseCaseProvider = Provider<GetTimelines>((ref) {
  return GetTimelines(ref.watch(timelineRepositoryProvider));
});

final getTimelineUseCaseProvider = Provider<GetTimeline>((ref) {
  return GetTimeline(ref.watch(timelineRepositoryProvider));
});

final createTimelineUseCaseProvider = Provider<CreateTimeline>((ref) {
  return CreateTimeline(ref.watch(timelineRepositoryProvider));
});

final updateTimelineUseCaseProvider = Provider<UpdateTimeline>((ref) {
  return UpdateTimeline(ref.watch(timelineRepositoryProvider));
});

final deleteTimelineUseCaseProvider = Provider<DeleteTimeline>((ref) {
  return DeleteTimeline(ref.watch(timelineRepositoryProvider));
});

final addEventToTimelineUseCaseProvider = Provider<AddEventToTimeline>((ref) {
  return AddEventToTimeline(ref.watch(timelineRepositoryProvider));
});

final updateEventInTimelineUseCaseProvider = Provider<UpdateEventInTimeline>((ref) {
  return UpdateEventInTimeline(ref.watch(timelineRepositoryProvider));
});

final deleteEventFromTimelineUseCaseProvider = Provider<DeleteEventFromTimeline>((ref) {
  return DeleteEventFromTimeline(ref.watch(timelineRepositoryProvider));
});

// ============================================================================
// State Notifier Providers
// ============================================================================

/// Provider for timelines list state
final timelinesProvider =
    StateNotifierProvider<TimelinesNotifier, TimelinesState>((ref) {
  return TimelinesNotifier(
    getTimelines: ref.watch(getTimelinesUseCaseProvider),
    deleteTimeline: ref.watch(deleteTimelineUseCaseProvider),
    createTimeline: ref.watch(createTimelineUseCaseProvider),
  );
});

/// Provider for single timeline detail state
final timelineDetailProvider = StateNotifierProvider.family<
    TimelineDetailNotifier, TimelineDetailState, String>((ref, timelineId) {
  return TimelineDetailNotifier(
    timelineId: timelineId,
    getTimeline: ref.watch(getTimelineUseCaseProvider),
    updateTimeline: ref.watch(updateTimelineUseCaseProvider),
    addEventToTimeline: ref.watch(addEventToTimelineUseCaseProvider),
    updateEventInTimeline: ref.watch(updateEventInTimelineUseCaseProvider),
    deleteEventFromTimeline: ref.watch(deleteEventFromTimelineUseCaseProvider),
    ref: ref,
  );
});

// ============================================================================
// State Notifiers
// ============================================================================

/// Notifier for managing timelines list state
class TimelinesNotifier extends StateNotifier<TimelinesState> {
  final GetTimelines getTimelines;
  final DeleteTimeline deleteTimeline;
  final CreateTimeline createTimeline;

  TimelinesNotifier({
    required this.getTimelines,
    required this.deleteTimeline,
    required this.createTimeline,
  }) : super(const TimelinesState());

  /// Load all timelines
  Future<void> loadTimelines() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getTimelines(const NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (timelines) {
        state = state.copyWith(
          isLoading: false,
          timelines: timelines,
        );
      },
    );
  }

  /// Add a new timeline
  Future<bool> addTimeline(Timeline timeline) async {
    final result = await createTimeline(CreateTimelineParams(timeline: timeline));

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (newTimeline) {
        state = state.copyWith(
          timelines: [...state.timelines, newTimeline],
        );
        return true;
      },
    );
  }

  /// Delete a timeline
  Future<bool> removeTimeline(String id) async {
    final result = await deleteTimeline(DeleteTimelineParams(id: id));

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          timelines: state.timelines.where((t) => t.id != id).toList(),
        );
        return true;
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Refresh a specific timeline in the list
  void refreshTimeline(Timeline updatedTimeline) {
    final index = state.timelines.indexWhere((t) => t.id == updatedTimeline.id);
    if (index != -1) {
      final updatedList = List<Timeline>.from(state.timelines);
      updatedList[index] = updatedTimeline;
      state = state.copyWith(timelines: updatedList);
    }
  }
}

/// Notifier for managing single timeline detail state
class TimelineDetailNotifier extends StateNotifier<TimelineDetailState> {
  final String timelineId;
  final GetTimeline getTimeline;
  final UpdateTimeline updateTimeline;
  final AddEventToTimeline addEventToTimeline;
  final UpdateEventInTimeline updateEventInTimeline;
  final DeleteEventFromTimeline deleteEventFromTimeline;
  final Ref ref;

  TimelineDetailNotifier({
    required this.timelineId,
    required this.getTimeline,
    required this.updateTimeline,
    required this.addEventToTimeline,
    required this.updateEventInTimeline,
    required this.deleteEventFromTimeline,
    required this.ref,
  }) : super(const TimelineDetailState());

  /// Load timeline details
  Future<void> loadTimeline() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getTimeline(GetTimelineParams(id: timelineId));

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (timeline) {
        state = state.copyWith(
          isLoading: false,
          timeline: timeline,
        );
      },
    );
  }

  /// Add event to timeline
  Future<bool> addEvent(TimelineEvent event) async {
    final result = await addEventToTimeline(
      AddEventToTimelineParams(timelineId: timelineId, event: event),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (updatedTimeline) {
        state = state.copyWith(timeline: updatedTimeline);
        // Refresh the timelines list
        ref.read(timelinesProvider.notifier).refreshTimeline(updatedTimeline);
        return true;
      },
    );
  }

  /// Update event in timeline
  Future<bool> updateEvent(TimelineEvent event) async {
    final result = await updateEventInTimeline(
      UpdateEventInTimelineParams(timelineId: timelineId, event: event),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (updatedTimeline) {
        state = state.copyWith(timeline: updatedTimeline);
        // Refresh the timelines list
        ref.read(timelinesProvider.notifier).refreshTimeline(updatedTimeline);
        return true;
      },
    );
  }

  /// Delete event from timeline
  Future<bool> deleteEvent(String eventId) async {
    final result = await deleteEventFromTimeline(
      DeleteEventFromTimelineParams(timelineId: timelineId, eventId: eventId),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (updatedTimeline) {
        state = state.copyWith(timeline: updatedTimeline);
        // Refresh the timelines list
        ref.read(timelinesProvider.notifier).refreshTimeline(updatedTimeline);
        return true;
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
