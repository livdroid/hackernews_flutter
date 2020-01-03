
import 'package:flutter_hcknews/entity/story.dart';

abstract class NewAndTopStoriesUseCase {
  Future<List<Story>> fetchStories();
}

class NewAndTopStoriesUseCaseImpl implements NewAndTopStoriesUseCase {
  final StoriesRepository _repository;
  
  NewAndTopStoriesUseCaseImpl(this._repository);

  @override
  Future<List<Story>> fetchStories() async {
    try {
      var storyList = await _repository.getNewAndTopStories();
      if (storyList.isEmpty) {
        throw EmptyStoriesException();
      }
      return storyList;
    } on GetStoriesException {
      throw FetchStoriesException();
    }
  }
}

class FetchStoriesException implements Exception {}

class EmptyStoriesException implements Exception {}

abstract class StoriesRepository {
  Future<List<Story>> getNewAndTopStories();
}

// Exception for Repository
class GetStoriesException implements Exception {}