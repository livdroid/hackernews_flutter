import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hcknews/blocs/new_and_top_stories_bloc.dart';
import 'package:flutter_hcknews/entity/story.dart';
import 'package:flutter_hcknews/repositories/stories_repository_impl.dart';
import 'package:flutter_hcknews/usecases/new_and_top_stories_use_case.dart';
import 'package:provider/provider.dart';

void main() => runApp(HackerNewsApp());

class HackerNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<NewAndTopStoriesBloc>(
      create: (context) => NewAndTopStoriesBloc(
          NewAndTopStoriesUseCaseImpl(StoriesRepositoryImpl())),
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

class NewAndTopStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<NewAndTopStoriesBloc>(context).fetchNewAndTopStories();

    return StreamBuilder<NewTopStoryState>(
      stream: Provider.of<NewAndTopStoriesBloc>(context).stream,
      builder:
          (BuildContext context, AsyncSnapshot<NewTopStoryState> snapshot) {
        if (snapshot.data is NewTopStoryLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data is NewTopStoryResultState) {
          var stories =
              (snapshot.data as NewTopStoryResultState<List<Story>>).value;
          return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  stories[index].text,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Chip(
                                      label: Text(
                                        "${stories[index].score}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepOrange[400],
                                    ),
                                    Text(
                                      " by ",
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      "${stories[index].by} ",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${(((DateTime.now().millisecondsSinceEpoch / 1000) - stories[index].time) / 3600).ceil()} days",
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 24,),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.deepOrange[400],
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  )),
                              child: Center(
                                  child: Text(
                                "${stories[index].kids.length}",
                                style: TextStyle(
                                    color: Colors.deepOrange[300],
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black12,
                    )
                  ],
                );
              });
        } else {
          return Container();
        }
      },
    );
  }
}
