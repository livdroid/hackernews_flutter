class Story {
  String _by;
  int _id;
  List<int> _kids;
  int _parent;
  String _text;
  int _time;
  String _type;

  Story(
      {String by,
        int id,
        List<int> kids,
        int parent,
        String text,
        int time,
        String type}) {
    this._by = by;
    this._id = id;
    this._kids = kids;
    this._parent = parent;
    this._text = text;
    this._time = time;
    this._type = type;
  }

  String get by => _by;
  set by(String by) => _by = by;
  int get id => _id;
  set id(int id) => _id = id;
  List<int> get kids => _kids;
  set kids(List<int> kids) => _kids = kids;
  int get parent => _parent;
  set parent(int parent) => _parent = parent;
  String get text => _text;
  set text(String text) => _text = text;
  int get time => _time;
  set time(int time) => _time = time;
  String get type => _type;
  set type(String type) => _type = type;

  Story.fromJson(Map<String, dynamic> json) {
    _by = json['by'];
    _id = json['id'];
    _kids = json['kids'].cast<int>();
    _parent = json['parent'];
    _text = json['text'];
    _time = json['time'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this._by;
    data['id'] = this._id;
    data['kids'] = this._kids;
    data['parent'] = this._parent;
    data['text'] = this._text;
    data['time'] = this._time;
    data['type'] = this._type;
    return data;
  }
}