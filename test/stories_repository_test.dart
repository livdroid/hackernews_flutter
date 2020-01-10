import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/repositories/stories_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockService extends Mock implements HackerNewsService {}

class StoriesRepositoryMock extends Mock implements StoriesRepositoryImpl {
  StoriesRepositoryMock(MockService hackerNewsService);
}

void main() {
  MockService hackerNewsService;
  StoriesRepositoryMock storiesRepositoryMock;

  var expectedStoryList = [Story(), Story()];

  setUp(() {
    storiesRepositoryMock = StoriesRepositoryMock(hackerNewsService);
  });

  test(
      ("When fetch new and top stories to the the repo"
          " And the request is successful"
          " Then should return a list of stories"), () async {
    when(storiesRepositoryMock.getNewAndTopStories())
        .thenAnswer((_) async => expectedStoryList);
    final response = await storiesRepositoryMock.getNewAndTopStories();
    expect(response, expectedStoryList);
  });
}
