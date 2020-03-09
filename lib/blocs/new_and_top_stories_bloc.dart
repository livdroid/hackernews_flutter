import 'dart:async';
import 'package:flutter_hcknews/blocs/base_bloc.dart';
import 'package:flutter_hcknews/plugin/share_plugin.dart';
import 'package:flutter_hcknews/plugin/url_launcher_plugin.dart';
import 'package:flutter_hcknews/blocs/viewmodels/new_and_top_story_view_model.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hcknews/entity/story.dart';

class NewAndTopStoriesBloc implements BaseBloc {
  final NewAndTopStoriesUseCase _useCase;
  final SharePlugin _sharePlugin;
  final URLLauncherPlugin _urlLauncherPlugin;
  NewAndTopStoriesBloc(this._useCase, this._sharePlugin, this._urlLauncherPlugin);

  final StreamController<NewAndTopStoryViewModel> _controller = StreamController<NewAndTopStoryViewModel>.broadcast();
  Stream<NewAndTopStoryViewModel> get stream => _controller.stream;

  NewAndTopStoryViewModel _viewModel = NewAndTopStoryViewModel();

  void fetchNewAndTopStories({bool refreshing = false}) async {
    try {
      _viewModel = _viewModel.copy(isRefreshing: refreshing, isLoading: !refreshing);
      _controller.sink.add(_viewModel);

      var storyList = await _useCase.fetchStories();
      _viewModel = _viewModel.copy(isRefreshing: false, isLoading: false, stories: storyList);
    } on FetchStoriesException {
      _viewModel = _viewModel.copy(isRefreshing: false, isLoading: false, error: "Network Error", stories: List());
    } on EmptyStoriesException {
      _viewModel = _viewModel.copy(isRefreshing: false, isLoading: false, error: "No story found", stories: List());
    }
    _controller.sink.add(_viewModel);
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