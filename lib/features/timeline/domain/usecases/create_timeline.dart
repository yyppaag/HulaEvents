import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../repositories/timeline_repository.dart';

/// Use case to create a new timeline
class CreateTimeline implements UseCase<Timeline, CreateTimelineParams> {
  final TimelineRepository repository;

  CreateTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(CreateTimelineParams params) {
    return repository.createTimeline(params.timeline);
  }
}

/// Parameters for CreateTimeline use case
class CreateTimelineParams {
  final Timeline timeline;

  const CreateTimelineParams({required this.timeline});
}
