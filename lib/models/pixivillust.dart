class PixivIllust {
  int id;
  String title;
  String illustType;
  Map imageUrls;
  String caption;
  int restrict;

  int userId;
  String displayName;
  String userName;
  Map userProfileImages;
  bool isUserFollowed;
  List jsonTags;
  List tools;
  String creationDate;
  int pageCount;
  int width;
  int height;
  int sanityLevel;
  int restrictLevel;
  Map? series;
  Map jsonMetaSinglePage;
  List jsonMetaPages;
  int totalViews;
  int totalBookmarks;
  bool isBookmarked;
  bool isVisible;
  bool isMuted;
  int? totalComments;

  @override
  String toString() {
    return "Instance of PixivIllust [$id, \"$title\"]";
  }

  PixivIllust.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        title = json["title"],
        illustType = json["type"],
        imageUrls = json["image_urls"],
        caption = json["caption"],
        restrict = json["restrict"],
        userId = json["user"]["id"],
        displayName = json["user"]["name"],
        userName = json["user"]["account"],
        userProfileImages = json["user"]["profile_image_urls"],
        isUserFollowed = json["user"]["is_followed"],
        jsonTags = json["tags"],
        tools = json["tools"],
        creationDate = json["create_date"],
        pageCount = json["page_count"],
        width = json["width"],
        height = json["height"],
        sanityLevel = json["sanity_level"],
        restrictLevel = json["x_restrict"],
        series = json["series"],
        jsonMetaSinglePage = json["meta_single_page"],
        jsonMetaPages = json["meta_pages"],
        totalViews = json["total_view"],
        totalBookmarks = json["total_bookmarks"],
        isBookmarked = json["is_bookmarked"],
        isVisible = json["visible"],
        isMuted = json["is_muted"],
        totalComments = json["total_comments"];
}
