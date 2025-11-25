import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/timeline.dart';
import '../entities/timeline_event.dart';

/// Timeline repository interface (domain layer contract)
abstract class TimelineRepository {
  /// Get all timelines
  Future<Either<Failure, List<Timeline>>> getTimelines();

  /// Get a single timeline by id
  Future<Either<Failure, Timeline>> getTimeline(String id);

  /// Create a new timeline
  Future<Either<Failure, Timeline>> createTimeline(Timeline timeline);

  /// Update an existing timeline
  Future<Either<Failure, Timeline>> updateTimeline(Timeline timeline);

  /// Delete a timeline
  Future<Either<Failure, void>> deleteTimeline(String id);

  /// Add event to timeline
  Future<Either<Failure, Timeline>> addEventToTimeline(
    String timelineId,
    TimelineEvent event,
  );

  /// Update event in timeline
  Future<Either<Failure, Timeline>> updateEventInTimeline(
    String timelineId,
    TimelineEvent event,
  );

  /// Delete event from timeline
  Future<Either<Failure, Timeline>> deleteEventFromTimeline(
    String timelineId,
    String eventId,
  );
}
