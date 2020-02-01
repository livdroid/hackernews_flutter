import 'package:flutter/material.dart';

import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/screens/components/item_story_widget.dart';

typedef RefreshCallback = Future<void> Function();

class StoryListWidget extends StatelessWidget {
  final RefreshCallback onRefresh;
  final List<Story> stories;
  final Function(Story) onShare;

  StoryListWidget({this.onRefresh, this.stories, this.onShare});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: stories.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ItemStoryWidget(story: stories[index], share: onShare);
          }),
    );
  }
}
