import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../entities/timeline_event.dart';
import '../repositories/timeline_repository.dart';

/// Use case to add an event to a timeline
class AddEventToTimeline implements UseCase<Timeline, AddEventToTimelineParams> {
  final TimelineRepository repository;

  AddEventToTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(AddEventToTimelineParams params) {
    return repository.addEventToTimeline(params.timelineId, params.event);
  }
}

/// Parameters for AddEventToTimeline use case
class AddEventToTimelineParams {
  final String timelineId;
  final TimelineEvent event;

  const AddEventToTimelineParams({
    required this.timelineId,
    required this.event,
  });
}
