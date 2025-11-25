import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/timeline.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../datasources/timeline_local_datasource.dart';
import '../models/timeline_model.dart';
import '../models/timeline_event_model.dart';

/// Implementation of TimelineRepository
class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineLocalDataSource localDataSource;

  TimelineRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Timeline>>> getTimelines() async {
    try {
      final timelineModels = localDataSource.getTimelines();
      final timelines = timelineModels.map((m) => m.toEntity()).toList();
      return Right(timelines);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get timelines: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> getTimeline(String id) async {
    try {
      final timelineModel = localDataSource.getTimeline(id);
      if (timelineModel == null) {
        return const Left(NotFoundFailure('Timeline not found'));
      }
      return Right(timelineModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> createTimeline(Timeline timeline) async {
    try {
      final timelineModel = TimelineModel.fromEntity(timeline);
      await localDataSource.saveTimeline(timelineModel);
      return Right(timeline);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to create timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> updateTimeline(Timeline timeline) async {
    try {
      final timelineModel = TimelineModel.fromEntity(timeline);
      await localDataSource.updateTimeline(timelineModel);
      // Return the updated timeline with new updatedAt
      final updated = timeline.copyWith(updatedAt: DateTime.now());
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to update timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTimeline(String id) async {
    try {
      await localDataSource.deleteTimeline(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> addEventToTimeline(
    String timelineId,
    TimelineEvent event,
  ) async {
    try {
      final timelineModel = localDataSource.getTimeline(timelineId);
      if (timelineModel == null) {
        return const Left(NotFoundFailure('Timeline not found'));
      }

      final updatedEvents = [
        ...timelineModel.eventModels,
        TimelineEventModel.fromEntity(event),
      ];

      final updatedTimeline = timelineModel.copyWithModel(
        eventModels: updatedEvents,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveTimeline(updatedTimeline);
      return Right(updatedTimeline.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to add event: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> updateEventInTimeline(
    String timelineId,
    TimelineEvent event,
  ) async {
    try {
      final timelineModel = localDataSource.getTimeline(timelineId);
      if (timelineModel == null) {
        return const Left(NotFoundFailure('Timeline not found'));
      }

      final updatedEvents = timelineModel.eventModels.map((e) {
        return e.id == event.id ? TimelineEventModel.fromEntity(event) : e;
      }).toList();

      final updatedTimeline = timelineModel.copyWithModel(
        eventModels: updatedEvents,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveTimeline(updatedTimeline);
      return Right(updatedTimeline.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to update event: $e'));
    }
  }

  @override
  Future<Either<Failure, Timeline>> deleteEventFromTimeline(
    String timelineId,
    String eventId,
  ) async {
    try {
      final timelineModel = localDataSource.getTimeline(timelineId);
      if (timelineModel == null) {
        return const Left(NotFoundFailure('Timeline not found'));
      }

      final updatedEvents = timelineModel.eventModels
          .where((e) => e.id != eventId)
          .toList();

      final updatedTimeline = timelineModel.copyWithModel(
        eventModels: updatedEvents,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveTimeline(updatedTimeline);
      return Right(updatedTimeline.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete event: $e'));
    }
  }
}
