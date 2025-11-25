import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../repositories/timeline_repository.dart';

/// Use case to get a single timeline by id
class GetTimeline implements UseCase<Timeline, GetTimelineParams> {
  final TimelineRepository repository;

  GetTimeline(this.repository);

  @override
  Future<Either<Failure, Timeline>> call(GetTimelineParams params) {
    return repository.getTimeline(params.id);
  }
}

/// Parameters for GetTimeline use case
class GetTimelineParams {
  final String id;

  const GetTimelineParams({required this.id});
}
