import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../lib/repositories/stories_repository_impl.dart';

String idListJson() => File('test/json/idlist.json').readAsStringSync();
String storyJson() => File('test/json/story.json').readAsStringSync();

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  group('get list of story ids', () {
    //Todo : Fix :$
    test(
      "When fetch new and top stories to the api"
      "And the request is a failure"
      "Then should return an exception",
      () async {
        when(mockClient.get(newAndTopStoriesURL)).thenThrow(ServerException());
        expect(() async => await mockClient.get(newAndTopStoriesURL),
            isInstanceOf<ServerException>());
      },
    );

    test(
      "When fetch new and top stories to the api"
      "And the request is successful"
      "Then should return a list of int as a Json",
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
          "And the request is successful"
          "Then should return a list of int",
          () async {
        when(mockClient.get(newAndTopStoriesURL))
            .thenAnswer((_) async => http.Response(idListJson(), 200));
        final response = await mockClient.get(newAndTopStoriesURL);
        if (response.statusCode == 200) {

          final expectedList =
          jsonDecode(File('test/json/idlist.json').readAsStringSync());

          final List<int> expectedAsInt =
          List<int>.from(expectedList).map((x) => x).toList();
          final List<int> listId =
          List<int>.from(jsonDecode(response.body).map((x) => x as int));

          expect(listId, expectedAsInt);
        }
      },
      );
  });

  group('get list of story from their id', () {

    final storyId = 214333;

    test(
      "When fetch new and top stories from their id to the api"
          "And the request is successful"
          "Then should return the good story as json",
          () async {
        when(mockClient.get('$storyById$storyId'))
            .thenAnswer((_) async => http.Response(storyJson(), 200));

        final response = await mockClient.get('$storyById$storyId');

        print('$storyById$storyId');
        if (response.statusCode == 200) {
          final expectedStoryJson = jsonDecode(File('test/json/story.json').readAsStringSync());
          expect(json.decode(response.body), expectedStoryJson);
        }
      },
      );
  });
}
