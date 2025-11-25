import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../repositories/timeline_repository.dart';

/// Use case to delete an event from a timeline
class DeleteEventFromTimeline implements UseCase<Timeline, DeleteEventFromTimelineParams> {
  final TimelineRepository repository;

  DeleteEventFromTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(DeleteEventFromTimelineParams params) {
    return repository.deleteEventFromTimeline(params.timelineId, params.eventId);
  }
}

/// Parameters for DeleteEventFromTimeline use case
class DeleteEventFromTimelineParams {
  final String timelineId;
  final String eventId;

  const DeleteEventFromTimelineParams({
    required this.timelineId,
    required this.eventId,
  });
}
