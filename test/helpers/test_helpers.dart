import 'package:mocktail/mocktail.dart';
import 'package:hula_events/features/timeline/domain/repositories/timeline_repository.dart';
import 'package:hula_events/features/timeline/data/datasources/timeline_local_datasource.dart';
import 'package:hula_events/features/timeline/domain/usecases/get_timelines.dart';
import 'package:hula_events/features/timeline/domain/usecases/get_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/create_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/update_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/delete_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/add_event_to_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/update_event_in_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/delete_event_from_timeline.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline_event.dart';
import 'package:hula_events/features/timeline/data/models/timeline_model.dart';

/// Mock classes for unit testing

// Repository mocks
class MockTimelineRepository extends Mock implements TimelineRepository {}

// Data source mocks
class MockTimelineLocalDataSource extends Mock implements TimelineLocalDataSource {}

// Use case mocks
class MockGetTimelines extends Mock implements GetTimelines {}
class MockGetTimeline extends Mock implements GetTimeline {}
class MockCreateTimeline extends Mock implements CreateTimeline {}
class MockUpdateTimeline extends Mock implements UpdateTimeline {}
class MockDeleteTimeline extends Mock implements DeleteTimeline {}
class MockAddEventToTimeline extends Mock implements AddEventToTimeline {}
class MockUpdateEventInTimeline extends Mock implements UpdateEventInTimeline {}
class MockDeleteEventFromTimeline extends Mock implements DeleteEventFromTimeline {}

// Fake classes for fallback values
class FakeTimeline extends Fake implements Timeline {}
class FakeTimelineEvent extends Fake implements TimelineEvent {}
class FakeTimelineModel extends Fake implements TimelineModel {}

/// Register all fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(FakeTimeline());
  registerFallbackValue(FakeTimelineEvent());
  registerFallbackValue(FakeTimelineModel());
}
