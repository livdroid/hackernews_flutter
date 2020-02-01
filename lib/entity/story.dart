class Story {
  String by;
  int id;
  List<int> kids;
  int parent;
  String title;
  int time;
  int score;
  String type;
  String url;

  Story(
      {this.by,
        this.id,
        this.kids,
        this.parent,
        this.title,
        this.time,
        this.score,
        this.type,
        this.url});

  Story.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    id = json['id'];
    kids = json['kids'] != null ? json['kids'].cast<int>() : <int>[];
    parent = json['parent'];
    title = json['title'] != null ? json['title'] : "";
    time = json['time'];
    score = json['score'] != null ? json['score'] : 0;
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['id'] = this.id;
    data['kids'] = this.kids;
    data['parent'] = this.parent;
    data['text'] = this.title;
    data['time'] = this.time;
    data['score'] = this.score;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}