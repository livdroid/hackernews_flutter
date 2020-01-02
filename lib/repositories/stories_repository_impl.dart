import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../entity/story.dart';
import '../usecases/new_and_top_stories_use_case.dart';

const newAndTopStoriesURL = 'https://hacker-news.firebaseio.com/v0/topstories/';
const storyById = 'https://hacker-news.firebaseio.com/v0/item/';

class StoriesRepositoryImpl implements StoriesRepository {
  final hackerNewsService = HackerNewsServiceImpl(client: http.Client());

  @override
  Future<List<Story>> getNewAndTopStories() async {
    final idList = await hackerNewsService.fetchNewsAndTopStories();
    final shortList = idList.sublist(0, 9);
    List<Story> list = await Future.wait(shortList.map((storyId) => hackerNewsService.getStoryById(storyId)));
    return list;
  }
}

class HackerNewsServiceImpl implements HackerNewsService {
  http.Client client;
  HackerNewsServiceImpl({@required this.client});

  Future<List<int>> fetchNewsAndTopStories() async {
    final response = await client.get('$newAndTopStoriesURL');
    if (response.statusCode == 200) {
      final listId = List<int>.from(json.decode(response.body).map((x) => x));
      return listId;
    } else {
        throw ServerException();
    }
  }

  Future<Story> getStoryById(int storyId) async {
    final response = await client.get('$storyById$storyId');
    if (response.statusCode == 200) {
      return Story.fromJson(json.decode(response.body));
    } else {
        throw ServerException();
    }
  }
}


abstract class HackerNewsService {
  Future<List<int>> fetchNewsAndTopStories();
}

class ServerException implements Exception {}