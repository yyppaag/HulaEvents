import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/create_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late CreateTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = CreateTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;

  group('CreateTimeline', () {
    test('should create timeline through the repository', () async {
      // arrange
      when(() => mockRepository.createTimeline(tTimeline))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(CreateTimelineParams(timeline: tTimeline));

      // assert
      expect(result, Right(tTimeline));
      verify(() => mockRepository.createTimeline(tTimeline)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository fails', () async {
      // arrange
      when(() => mockRepository.createTimeline(tTimeline))
          .thenAnswer((_) async => const Left(CacheFailure('Failed to save')));

      // act
      final result = await usecase(CreateTimelineParams(timeline: tTimeline));

      // assert
      expect(result, const Left(CacheFailure('Failed to save')));
      verify(() => mockRepository.createTimeline(tTimeline)).called(1);
    });

    test('should return StorageFailure when storage is unavailable', () async {
      // arrange
      when(() => mockRepository.createTimeline(tTimeline))
          .thenAnswer((_) async => const Left(StorageFailure('Storage unavailable')));

      // act
      final result = await usecase(CreateTimelineParams(timeline: tTimeline));

      // assert
      expect(result, const Left(StorageFailure('Storage unavailable')));
    });

    test('should create empty timeline', () async {
      // arrange
      final emptyTimeline = TestFixtures.emptyTimeline;
      when(() => mockRepository.createTimeline(emptyTimeline))
          .thenAnswer((_) async => Right(emptyTimeline));

      // act
      final result = await usecase(CreateTimelineParams(timeline: emptyTimeline));

      // assert
      expect(result, Right(emptyTimeline));
      verify(() => mockRepository.createTimeline(emptyTimeline)).called(1);
    });
  });

  group('CreateTimelineParams', () {
    test('should create params with timeline', () {
      final params = CreateTimelineParams(timeline: tTimeline);
      expect(params.timeline, tTimeline);
    });
  });
}
