class Story {
  String by;
  int id;
  List<int> kids;
  int parent;
  String text;
  int time;
  int score;
  String type;

  Story(
      {this.by,
        this.id,
        this.kids,
        this.parent,
        this.text,
        this.time,
        this.score,
        this.type});

  Story.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    id = json['id'];
    kids = json['kids'] != null ? json['kids'].cast<int>() : <int>[];
    parent = json['parent'];
    text = json['title'] != null ? json['title'] : "";
    time = json['time'];
    score = json['score'] != null ? json['score'] : 0;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['id'] = this.id;
    data['kids'] = this.kids;
    data['parent'] = this.parent;
    data['text'] = this.text;
    data['time'] = this.time;
    data['score'] = this.score;
    data['type'] = this.type;
    return data;
  }
}