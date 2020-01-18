import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_hcknews/entity/story.dart';

class MockStoriesRepository extends Mock implements StoriesRepository {}

void main() {
  test(
      "When fetch new and top stories "
      "And repository throw an error "
      "Then should throw fetch stories exception", () async {
    var repository = MockStoriesRepository();
    var useCase = NewAndTopStoriesUseCaseImpl(repository);

    when(repository.getNewAndTopStories()).thenThrow(GetStoriesException());

    useCase.fetchStories().catchError(expectAsync1((e) {
      expect(e, isInstanceOf<FetchStoriesException>());
    }));

    verify(repository.getNewAndTopStories());
  });

  test(
      "When fetch new and top stories "
      "And repository return an empty story list "
      "Then should throw EmptyStoriesException", () async {
    var repository = MockStoriesRepository();
    var useCase = NewAndTopStoriesUseCaseImpl(repository);

    when(repository.getNewAndTopStories())
        .thenAnswer((_) => Future<List<Story>>.value([]));

    useCase.fetchStories().catchError(expectAsync1((e) {
      expect(e, isInstanceOf<EmptyStoriesException>());
    }));

    verify(repository.getNewAndTopStories());
  });

  test(
      "When fetch new and top stories "
      "And repository return a filled story list "
      "Then should return a list of story", () async {
    var repository = MockStoriesRepository();
    var useCase = NewAndTopStoriesUseCaseImpl(repository);
    var expectedStoryList = [
      Story(),
      Story(),
      Story(),
      Story()
    ];

    when(repository.getNewAndTopStories())
        .thenAnswer((_) => Future<List<Story>>.value(expectedStoryList));

    var storyList = await useCase.fetchStories();

    expect(storyList, expectedStoryList);
    verify(repository.getNewAndTopStories());
  });
}
