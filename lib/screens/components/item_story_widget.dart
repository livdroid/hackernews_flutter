import 'package:flutter/material.dart';
import 'package:flutter_hcknews/entity/story.dart';

class ItemStoryWidget extends StatelessWidget {
  final Story story;

  ItemStoryWidget({Key key, this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      story.title,
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
                            "${story.score}",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.deepOrange[400],
                        ),
                        Text(
                          " by ",
                          style: TextStyle(color: Colors.black38),
                        ),
                        Text(
                          "${story.by} ",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        Expanded(
                          child: Text(
                            "${(((DateTime.now().millisecondsSinceEpoch / 1000) - story.time) / 3600).ceil()} days",
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 24,
              ),
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
                        "${story.kids.length}",
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
  }
}
