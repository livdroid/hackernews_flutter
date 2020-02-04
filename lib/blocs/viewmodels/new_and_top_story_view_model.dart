
import 'package:flutter_hcknews/entity/story.dart';

class NewAndTopStoryViewModel {
  bool _isLoading;
  bool _isRefreshing;
  List<Story> _stories;
  String _error;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  List<Story> get stories => _stories;
  String get error => _error;

  NewAndTopStoryViewModel({List<Story> stories, bool isLoading, bool isRefreshing, String error}) {
    _stories = stories ?? List();
    _isRefreshing = isRefreshing ?? false;
    _isLoading = isLoading ?? false;
    _error = error ?? "";
  }

  NewAndTopStoryViewModel copy({List<Story> stories, bool isLoading, bool isRefreshing, String error}) {
    return NewAndTopStoryViewModel(
      stories: stories ?? _stories,
      isLoading: isLoading ?? _isLoading,
      isRefreshing: isRefreshing ?? _isRefreshing,
      error: error ?? _error
    );
  }
}