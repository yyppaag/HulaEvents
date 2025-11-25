import 'package:equatable/equatable.dart';
import '../../domain/entities/timeline.dart';

/// State for timeline list
class TimelinesState extends Equatable {
  final List<Timeline> timelines;
  final bool isLoading;
  final String? errorMessage;

  const TimelinesState({
    this.timelines = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TimelinesState copyWith({
    List<Timeline>? timelines,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimelinesState(
      timelines: timelines ?? this.timelines,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [timelines, isLoading, errorMessage];
}

/// State for single timeline detail
class TimelineDetailState extends Equatable {
  final Timeline? timeline;
  final bool isLoading;
  final String? errorMessage;

  const TimelineDetailState({
    this.timeline,
    this.isLoading = false,
    this.errorMessage,
  });

  TimelineDetailState copyWith({
    Timeline? timeline,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimelineDetailState(
      timeline: timeline ?? this.timeline,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [timeline, isLoading, errorMessage];
}

/// State for create/edit timeline form
class TimelineFormState extends Equatable {
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  const TimelineFormState({
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  TimelineFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return TimelineFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];
}
