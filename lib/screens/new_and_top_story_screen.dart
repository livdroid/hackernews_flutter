import 'package:flutter/material.dart';
import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/entity/story.dart';
import 'package:provider/provider.dart';

import 'components/item_story_widget.dart';

class NewAndTopStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NewAndTopStoriesBloc>(context);
    bloc.fetchNewAndTopStories();

    return StreamBuilder<NewTopStoryState>(
      stream: bloc.stream,
      builder:
          (BuildContext context, AsyncSnapshot<NewTopStoryState> snapshot) {
        if (snapshot.data is NewTopStoryErrorState) {
          return NewAndTopStoryErrorWidget();
        } else if (snapshot.data is NewTopStoryResultState) {
          var stories =
              (snapshot.data as NewTopStoryResultState<List<Story>>).value;
          return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return ItemStoryWidget(story: stories[index]);
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class NewAndTopStoryErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Something went wrong. Try again later"),
    );
  }
}

