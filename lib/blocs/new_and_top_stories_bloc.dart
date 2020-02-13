import 'dart:async';
import 'package:flutter_hcknews/blocs/base_bloc.dart';
import 'package:flutter_hcknews/plugin/share_plugin.dart';
import 'package:flutter_hcknews/plugin/url_launcher_plugin.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hcknews/entity/story.dart';

class NewAndTopStoriesBloc implements BaseBloc {
  final NewAndTopStoriesUseCase _useCase;
  final SharePlugin _sharePlugin;
  final URLLauncherPlugin _urlLauncherPlugin;
  NewAndTopStoriesBloc(this._useCase, this._sharePlugin, this._urlLauncherPlugin);

  final StreamController<NewTopStoryState> _controller = StreamController<NewTopStoryState>.broadcast();
  Stream<NewTopStoryState> get stream => _controller.stream;

  void fetchNewAndTopStories({bool refreshing = false}) async {
    try {
      if (refreshing) {
        _controller.sink.add(NewTopStoryRefreshState());
      } else {
        _controller.sink.add(NewTopStoryLoadingState());
      }
      var storyList = await _useCase.fetchStories();
      _controller.sink.add(NewTopStoryResultState<List<Story>>(storyList));
    } on FetchStoriesException {
      _controller.sink.add(NewTopStoryErrorState("Network Error"));
    } on EmptyStoriesException {
      _controller.sink.add(NewTopStoryErrorState("No Story found"));
    }
  }

  @override
  void dispose() {
    _controller.close();
  }

  Future<bool> shareStory(String url) async {
    try {
      await _sharePlugin.share(url);
      return true;
    } on SharePlateformException {
      return false;
    } on ShareFormatException {
      return false;
    }
  }

  Future<bool> launchUrl(String url) async {
    try {
      await _urlLauncherPlugin.launchUrl(url);
      return true;
    } on URLLauncherPlateformException {
      return false;
    }
  }
}


class NewTopStoryState {}

class NewTopStoryLoadingState extends NewTopStoryState {}

class NewTopStoryRefreshState extends NewTopStoryState {}

class NewTopStoryResultState<T> extends NewTopStoryState {
  T _value;

  NewTopStoryResultState(this._value);

  T get value => _value;
}

class NewTopStoryErrorState extends NewTopStoryState {
  String _errorMsg;

  NewTopStoryErrorState(this._errorMsg);

  String get error => _errorMsg;
}
