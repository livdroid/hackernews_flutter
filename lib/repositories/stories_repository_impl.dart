import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const newAndTopStoriesURL =
    'https://hacker-news.firebaseio.com/v0/topstories.json';
const storyById = 'https://hacker-news.firebaseio.com/v0/item/';

class StoriesRepositoryImpl implements StoriesRepository {
  HackerNewsService hackerNewsService;
  StoriesRepositoryImpl({this.hackerNewsService});

  @override
  Future<List<Story>> getNewAndTopStories() async {
    final idList = await hackerNewsService.fetchNewsAndTopStories();
    final shortList = idList.sublist(0, 9);
    List<Story> list = await Future.wait(
        shortList.map((storyId) => hackerNewsService.getStoryById(storyId)));
    return list;
  }
}

class HackerNewsServiceImpl implements HackerNewsService {
  Client client = http.Client();

  Future<List<int>> fetchNewsAndTopStories() async {
    final response = await client.get('$newAndTopStoriesURL');
    if (response.statusCode == 200) {
      return compute(parseStoryList, response.body);
    } else {
      throw ServerException();
    }
  }

  Future<Story> getStoryById(int storyId) async {
    final response = await client.get('$storyById$storyId.json');
    if (response.statusCode == 200) {
      return compute(parseStory, response.body);
    } else {
      throw ServerException();
    }
  }
}

abstract class HackerNewsService {
  Future<List<int>> fetchNewsAndTopStories();
  Future<Story> getStoryById(int storyId) {}
}

Story parseStory(String body) {
  return Story.fromJson(json.decode(body));
}

List<int> parseStoryList(String body) {
  final listId = List<int>.from(json.decode(body).map((x) => x));
  return listId;
}

class ServerException implements Exception {}
