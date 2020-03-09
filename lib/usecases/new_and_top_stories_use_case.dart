
import 'package:flutter_hcknews/entity/story.dart';

abstract class NewAndTopStoriesUseCase {
  Future<List<Story>> fetchStories({int page = 0});
}

class NewAndTopStoriesUseCaseImpl implements NewAndTopStoriesUseCase {
  final StoriesRepository _repository;
  
  NewAndTopStoriesUseCaseImpl(this._repository);

  @override
  Future<List<Story>> fetchStories({int page = 0}) async {
    try {
      var storyList = await _repository.getNewAndTopStories(page: page);
      if (storyList.isEmpty) {
        throw EmptyStoriesException();
      }
      return storyList;
    } on GetStoriesException {
      throw FetchStoriesException();
    } on NoMoreStoriesException {
      throw EndOfStoriesException();
    }
  }
}

class FetchStoriesException implements Exception {}

class EmptyStoriesException implements Exception {}

class EndOfStoriesException implements Exception {}

abstract class StoriesRepository {
  Future<List<Story>> getNewAndTopStories({int page = 0});
}

// Exception for Repository
class GetStoriesException implements Exception {}

class NoMoreStoriesException implements Exception {}