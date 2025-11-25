import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../entities/timeline_event.dart';
import '../repositories/timeline_repository.dart';

/// Use case to update an event in a timeline
class UpdateEventInTimeline implements UseCase<Timeline, UpdateEventInTimelineParams> {
  final TimelineRepository repository;

  UpdateEventInTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(UpdateEventInTimelineParams params) {
    return repository.updateEventInTimeline(params.timelineId, params.event);
  }
}

/// Parameters for UpdateEventInTimeline use case
class UpdateEventInTimelineParams {
  final String timelineId;
  final TimelineEvent event;

  const UpdateEventInTimelineParams({
    required this.timelineId,
    required this.event,
  });
}
