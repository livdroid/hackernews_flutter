import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../lib/entity/story.dart';


class MockUseCase extends Mock implements NewAndTopStoriesUseCase {}

void main() {
  test(
      "When we ask bloc to fetch stories from the use case "
      "And the use case throw FetchStoriesException "
      "Then should send ErrorState after LoadingState", () {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);

    when(useCase.fetchStories()).thenThrow(FetchStoriesException());

    expect(
        bloc.stream,
        emitsInOrder([
          isInstanceOf<LoadingState>(),
          isInstanceOf<ErrorState>()
        ])
    );

    bloc.fetchNewAndTopStories();
  });

  test(
      "When we ask bloc to fetch stories from the use case "
      "And the use case throw EmptyStoriesException "
      "Then should send ErrorState after LoadingState", () {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);

    when(useCase.fetchStories()).thenThrow(EmptyStoriesException());

    expect(
        bloc.stream,
        emitsInOrder([
          isInstanceOf<LoadingState>(),
          isInstanceOf<ErrorState>()
        ])
    );

    bloc.fetchNewAndTopStories();
  });

  test(
      "When we ask bloc to fetch stories from the use case "
      "And the use case return list of Story"
      "Then should send ", () {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);

    when(useCase.fetchStories()).thenAnswer(
            (_) => Future<List<Story>>.value([
              Story(),
              Story(),
              Story()
            ])
    );

    expect(
        bloc.stream,
        emitsInOrder([
          isInstanceOf<LoadingState>(),
          isInstanceOf<ResultState<List<Story>>>()
        ])
    );

    bloc.fetchNewAndTopStories();
  });
}
