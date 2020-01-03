import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/repositories/stories_repository_impl.dart';

String idListJson() => File('test/json/idlist.json').readAsStringSync();

String storyJson() => File('test/json/story.json').readAsStringSync();

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient mockClient;
  HackerNewsServiceImpl hackerNewsService;

  setUp(() {
    mockClient = MockClient();
    hackerNewsService = HackerNewsServiceImpl(client: http.Client());
  });

  group('get list of story ids', () {

    test(
      "When fetch new and top stories to the api"
      " And the request is successful"
      " Then should return a list of int as a Json",
      () async {
        when(mockClient.get(newAndTopStoriesURL))
            .thenAnswer((_) async => http.Response(idListJson(), 200));
        final response = await mockClient.get(newAndTopStoriesURL);
        if (response.statusCode == 200) {
          final expectedList =
              jsonDecode(File('test/json/idlist.json').readAsStringSync());
          expect(jsonDecode(response.body), expectedList);
        }
      },
    );

    test(
      "When fetch new and top stories to the api"
      " And the request is successful"
      " Then should return a list of int",
      () async {
        when(mockClient.get(newAndTopStoriesURL))
            .thenAnswer((_) async => http.Response(idListJson(), 200));
        List<int> response = await hackerNewsService.fetchNewsAndTopStories();
        expect(response, isInstanceOf<List<int>>());
      },
    );
  });

  group('get list of story from their id', () {
    final storyId = 214333;

    test(
      "When fetch new and top stories from their id to the api"
      " And the request is successful"
      " Then should return the good story as json",
      () async {
        when(mockClient.get('$storyById$storyId'))
            .thenAnswer((_) async => http.Response(storyJson(), 200));
        final response = await mockClient.get('$storyById$storyId');
        if (response.statusCode == 200) {
          final expectedStoryJson =
              jsonDecode(File('test/json/story.json').readAsStringSync());
          expect(jsonDecode(response.body), expectedStoryJson);
        }
      },
    );

    test(
      "When fetch new and top stories to the api"
      " And the request is successful"
      " Then should return a story",
      () async {
        when(mockClient.get('$storyById$storyId'))
            .thenAnswer((_) async => http.Response(storyJson(), 200));
        Story response = await hackerNewsService.getStoryById(storyId);
        expect(response, isInstanceOf<Story>());
      },
    );
  });
}
