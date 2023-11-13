class ModelForVidesClass {
  ModelForVidesClass({
    this.videos = const [],
    this.appBackgroundHexColor = "",
  });

  ModelForVidesClass.fromJson(dynamic json) {
    appBackgroundHexColor = json['appBackgroundHexColor']??"#B59CCA";
    if (json['videos'] != null) {
      videos = [];
      json['videos'].forEach((v) {
        videos.add(Videos.fromJson(v));
      });
    }
    
  }

  List<Videos> videos = const [];
  String appBackgroundHexColor = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appBackgroundHexColor'] = appBackgroundHexColor;
    map['videos'] = videos.map((v) => v.toJson()).toList();
    return map;
  }
}

class Videos {
  Videos({
    this.description = "",
    this.videourl = "",
    this.thumb = "",
    this.title = "",
  });

  Videos.fromJson(dynamic json) {
    description = json['videoDescription'] ?? "";
    videourl = json['videoUrl'] ?? "";
    thumb = json['videoThumbnail'] ?? "https://i.ibb.co/99bBzKk/NoVideo.png";
    title = json['videoTitle'] ?? "";
  }

  String description = "";
  String videourl = "";
  String thumb = "";
  String title = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['videourl'] = videourl;
    map['thumb'] = thumb;
    map['title'] = title;
    return map;
  }
}
