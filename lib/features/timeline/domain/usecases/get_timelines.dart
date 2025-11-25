import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeline.dart';
import '../repositories/timeline_repository.dart';

/// Use case to get all timelines
class GetTimelines implements UseCase<List<Timeline>, NoParams> {
  final TimelineRepository repository;

  GetTimelines(this.repository);

  @override
  Future<Either<Failure, List<Timeline>>> call(NoParams params) {
    return repository.getTimelines();
  }
}
