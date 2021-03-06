import 'package:flutter/material.dart';
import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/blocs/viewmodels/new_and_top_story_view_model.dart';
import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/screens/components/story_list_widget.dart';
import 'package:provider/provider.dart';

class NewAndTopStoryScreen extends StatefulWidget {
  @override
  _NewAndTopStoryScreenState createState() => _NewAndTopStoryScreenState();
}

class _NewAndTopStoryScreenState extends State<NewAndTopStoryScreen> {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NewAndTopStoriesBloc>(context);
    bloc.fetchNewAndTopStories();

    return StreamBuilder<NewAndTopStoryViewModel>(
      stream: bloc.stream,
      builder:
          (BuildContext context, AsyncSnapshot<NewAndTopStoryViewModel> snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        if (snapshot.data.error.isNotEmpty) {
          return NewAndTopStoryErrorWidget();
        }
        return AnimatedCrossFade(
            sizeCurve: Curves.easeIn,
            crossFadeState: snapshot.data.isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 300),
            firstChild: Center(child: CircularProgressIndicator()),
            secondChild: StoryListWidget(
              onRefresh: () async {
                await bloc.fetchNewAndTopStories(refreshing: true);
              },
              onShare: (Story story) {
                bloc.shareStory(story.url);
              },
              onTapStory: (String url) async {
                await bloc.launchUrl(url);
              },
              stories: snapshot.data.stories,
            ));
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
