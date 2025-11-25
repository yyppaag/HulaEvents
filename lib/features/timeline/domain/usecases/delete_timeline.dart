import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/timeline_repository.dart';

/// Use case to delete a timeline
class DeleteTimeline implements UseCase<void, DeleteTimelineParams> {
  final TimelineRepository repository;

  DeleteTimeline(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTimelineParams params) {
    return repository.deleteTimeline(params.id);
  }
}

/// Parameters for DeleteTimeline use case
class DeleteTimelineParams {
  final String id;

  const DeleteTimelineParams({required this.id});
}
