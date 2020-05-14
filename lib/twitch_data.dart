class TwitchClipContainer {
  var clips;

  TwitchClipContainer.fromJson(Map<String, dynamic> json) {
    Iterable iterable = json['clips'];
    clips = iterable.map((e) => TwitchClip.fromJson(e)).toList();
  }
}

class TwitchClip {
  var slug;
  var trackingId;
  var url;
  var embedUrl;
  var broadcaster;
  var game;
  var language;
  var title;
  var views;
  var duration;
  var created_at;
  var thumbnails;

  TwitchClip.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    trackingId = json['tracking_id'];
    url = json['url'];
    embedUrl = json['embedUrl'];
    broadcaster = TwitchBroadcaster.fromJson(json['broadcaster']);
    game = json['game'];
    language = json['language'];
    title = json['title'];
    views = json['views'];
    duration = json['duration'];
    created_at = json['created_at'];
    thumbnails = TwitchThumbnails.fromJson(json['thumbnails']);
  }
}

class TwitchBroadcaster {
  var id;
  var name;
  var displayName;
  var channelUrl;
  var logo;

  TwitchBroadcaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
    channelUrl = json['channel_url'];
    logo = json['logo'];
  }
}

class TwitchThumbnails {
  var tiny;
  var small;
  var medium;

  TwitchThumbnails.fromJson(Map<String, dynamic> json) {
    tiny = json['tiny'];
    small = json['small'];
    medium = json['medium'];
  }
}
