import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../repositories/timeline_repository.dart';

/// Use case to update an existing timeline
class UpdateTimeline implements UseCase<Timeline, UpdateTimelineParams> {
  final TimelineRepository repository;

  UpdateTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(UpdateTimelineParams params) {
    return repository.updateTimeline(params.timeline);
  }
}

/// Parameters for UpdateTimeline use case
class UpdateTimelineParams {
  final Timeline timeline;

  const UpdateTimelineParams({required this.timeline});
}
