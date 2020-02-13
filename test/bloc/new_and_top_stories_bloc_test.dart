import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/plugin/share_plugin.dart';
import 'package:flutter_hcknews/plugin/url_launcher_plugin.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUseCase extends Mock implements NewAndTopStoriesUseCase {}

class MockSharePlugin extends Mock implements SharePlugin {}

class MockUrlLauncherPlugin extends Mock implements URLLauncherPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockUseCase useCase;
  NewAndTopStoriesBloc bloc;
  var mockSharePlugin = MockSharePlugin();
  var mockUrlLauncherPlugin = MockUrlLauncherPlugin();

  setUp(() async {
    useCase = MockUseCase();
    bloc =
        NewAndTopStoriesBloc(useCase, mockSharePlugin, mockUrlLauncherPlugin);
  });

  test(
      "When we ask bloc to fetch stories from the use case "
      "And the use case throw FetchStoriesException "
      "Then should send ErrorState after LoadingState", () {
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

  test(
      "When we ask bloc to share a url"
      "And the url is valid"
      "Then the method is called", () async {
    final url = 'http://www.google.fr';
    bloc.shareStory(url);
    verify(await mockSharePlugin.share(url));
  });

  test(
      "When we ask bloc to share a url"
      "And the url is NOT valid and an exception is catch"
      "it returns false", () async {
    final url = 'http://www.google.fr';
    when(mockSharePlugin.share(url)).thenThrow(SharePlateformException());
    expect(await bloc.shareStory(url), false);
  });

  test(
      "When we ask bloc to share a url"
          "And the library action is NOT valid and an exception is catch"
          "it returns false", () async {
    final url = '';
    when(mockSharePlugin.share(url)).thenThrow(ShareFormatException());
    expect(await bloc.shareStory(url), false);
  });

  test(
      "When we ask bloc to open a url"
          "And the library action is NOT valid and an exception is catch"
          "it returns false", () async {
    final url = 'http://www.google.fr';
    when(mockUrlLauncherPlugin.launchUrl(url)).thenThrow(URLLauncherPlateformException());
    expect(await bloc.launchUrl(url), false);
  });
}
