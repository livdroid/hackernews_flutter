import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//import 'package:flutter/services.dart';
//import 'package:share/share.dart';

import 'package:flutter_hcknews/entity/story.dart';

class MockUseCase extends Mock implements NewAndTopStoriesUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
          isInstanceOf<NewTopStoryLoadingState>(),
          isInstanceOf<NewTopStoryErrorState>()
        ]));

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
          isInstanceOf<NewTopStoryLoadingState>(),
          isInstanceOf<NewTopStoryErrorState>()
        ]));

    bloc.fetchNewAndTopStories();
  });

  test(
      "When we ask bloc to fetch stories from the use case "
      "And the use case return list of Story"
      "Then should send it", () {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);

    when(useCase.fetchStories()).thenAnswer(
        (_) => Future<List<Story>>.value([Story(), Story(), Story()]));

    expect(
        bloc.stream,
        emitsInOrder([
          isInstanceOf<NewTopStoryLoadingState>(),
          isInstanceOf<NewTopStoryResultState<List<Story>>>()
        ]));

    bloc.fetchNewAndTopStories();
  });

  test(
      "When we ask bloc to refetch stories from the use case "
      "And the use case return list of Story"
      "Then should send it", () {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);

    when(useCase.fetchStories()).thenAnswer(
        (_) => Future<List<Story>>.value([Story(), Story(), Story()]));

    expect(
        bloc.stream,
        emitsInOrder([
          isInstanceOf<NewTopStoryRefreshState>(),
          isInstanceOf<NewTopStoryResultState<List<Story>>>()
        ]));

    bloc.fetchNewAndTopStories(refreshing: true);
  });

  //share url
  /*
  test(
      "When we ask bloc to share a url"
      "And the url is null and cannot be shared"
      "Then should return exception", () async {
    var bloc = NewAndTopStoriesBloc(MockUseCase());
    expect(
      bloc.interactionStream,
      equals(InteractionErrorState),
    );

  });

  test(
      "When we ask bloc to share a url"
      "And the url is valid"
      "Then should return a good state", () async {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);
    expect(
      bloc.interactionStream, emits(InteractionState),
    );
  });

  //Launch url
  test(
      "When we ask bloc to open stories in a browser"
      "And the url is null and cannot launch browser"
      "Then should return a bad state", () async {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);
    expect(bloc.interactionStream, emits(InteractionErrorState));
  });

  test(
      "When we ask bloc to open stories in a browser"
      "And the url is not null"
      "Then should return a good state", () async {
    var useCase = MockUseCase();
    var bloc = NewAndTopStoriesBloc(useCase);
    expect(
      bloc.interactionStream, emits(InteractionState),
    );
  });
   */
}
