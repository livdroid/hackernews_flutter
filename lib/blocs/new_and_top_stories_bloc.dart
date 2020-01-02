import 'dart:async';
import 'package:flutter_hcknews/blocs/base_bloc.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';

import '../entity/story.dart';

class NewAndTopStoriesBloc implements BaseBloc {
  final NewAndTopStoriesUseCase _useCase;

  final StreamController _controller = StreamController<State>.broadcast();

  NewAndTopStoriesBloc(this._useCase);

  Stream<State> get stream => _controller.stream;

  void fetchNewAndTopStories() async {
    try {
      _controller.sink.add(LoadingState());
      var storyList = await _useCase.fetchStories();
      _controller.sink.add(ResultState<List<Story>>(storyList));
    } on FetchStoriesException {
      _controller.sink.add(ErrorState("Network Error"));
    } on EmptyStoriesException {
      _controller.sink.add(ErrorState("No Story found"));
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}

class State {}

class LoadingState extends State {}

class ResultState<T> extends State {
  T _value;

  ResultState(this._value);

  T get value => _value;
}

class ErrorState extends State {
  String _errorMsg;

  ErrorState(this._errorMsg);

  String get error => _errorMsg;
}