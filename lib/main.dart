import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/plugin/share_plugin.dart';
import 'package:flutter_hcknews/plugin/url_launcher_plugin.dart';
import 'package:flutter_hcknews/repositories/stories_repository_impl.dart';
import 'package:flutter_hcknews/screens/new_and_top_story_screen.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:provider/provider.dart';

void main() => runApp(HackerNewsApp());

class HackerNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<NewAndTopStoriesBloc>(
      create: (context) => NewAndTopStoriesBloc(
          NewAndTopStoriesUseCaseImpl(
              StoriesRepositoryImpl(
                  hackerNewsService: HackerNewsServiceImpl()
              )
          ),
        SharePlugin(),
        URLLauncherPlugin()
      ),
      dispose: (context, value) => value.dispose(),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
            accentColor: Colors.deepOrange[400],
            appBarTheme: AppBarTheme(color: Colors.deepOrange[400])),
        home: Scaffold(
          appBar: AppBar(
            title: Text("HKNews"),
          ),
          body: Container(
            child: NewAndTopStoryScreen(),
          ),
        ),
      ),
    );
  }
}


