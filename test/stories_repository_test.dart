import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/repositories/stories_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HackerNewsServiceMock extends Mock implements HackerNewsService {}

void main() {
  HackerNewsServiceMock hackerNewsService;

  setUp(() {
    hackerNewsService = HackerNewsServiceMock();
  });

  var expectedInt = [1, 2];
  var expectedStory = Story();
  List<Story> stories = List<Story>();

  test(
      ("When fetch new and top stories to the the repo"
          " And the request is successful"
          " Then should return a list of stories"), () async {
    when(hackerNewsService.fetchNewsAndTopStories())
        .thenAnswer((_) async => expectedInt);

    when(hackerNewsService.getStoryById(0))
        .thenAnswer((_) async => expectedStory);

    final idList = await hackerNewsService.fetchNewsAndTopStories();
    final story = await hackerNewsService.getStoryById(idList[0]);
    stories.add(story);
    expect(stories, isInstanceOf<List<Story>>());
  });
}
