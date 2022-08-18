import 'dart:ffi';

class PixivUser {
  int userId;
  String displayName;
  String userName;
  Map profileImageUrls; // Array of 3 Strings
  String comment;
  bool isFollowed;
  String? webpage;
  String? gender;
  String? birthDay;
  int? birthYear;
  String region;
  int addressId;
  String countryCode;
  String job;
  int jobId;
  int totalFollowUsers;
  int totalMyPixivUsers;
  int totalIllusts;
  int totalManga;
  int totalNovels;
  int totalIllustBookmarksPublic;
  int totalIllustSeries;
  int totalNovelSeries;
  String? backgroundImageUrl;
  String? twitterAccount;
  String? twitterUrl;
  String? pawooUrl;
  bool isPremium;
  bool isCustomProfileImage;

  @override
  String toString() {
    return "Instance of PixivUser [$userId, \"$displayName\"]";
  }

  PixivUser.fromJson(Map<dynamic, dynamic> json)
      : userId = json["user"]["id"],
        displayName = json["user"]["name"],
        userName = json["user"]["account"],
        profileImageUrls = json["user"]["profile_image_urls"],
        comment = json["user"]["comment"],
        isFollowed = json["user"]["is_followed"],
        webpage = json["profile"]["webpage"],
        gender = json["profile"]["gender"],
        birthDay = json["profile"]["birth_day"],
        birthYear = json["profile"]["birth_year"],
        region = json["profile"]["region"],
        addressId = json["profile"]["address_id"],
        countryCode = json["profile"]["country_code"],
        job = json["profile"]["job"],
        jobId = json["profile"]["job_id"],
        totalFollowUsers = json["profile"]["total_follow_users"],
        totalMyPixivUsers = json["profile"]["total_mypixiv_users"],
        totalIllusts = json["profile"]["total_illusts"],
        totalManga = json["profile"]["total_manga"],
        totalNovels = json["profile"]["total_novels"],
        totalIllustBookmarksPublic =
            json["profile"]["total_illust_bookmarks_public"],
        totalIllustSeries = json["profile"]["total_illust_series"],
        totalNovelSeries = json["profile"]["total_novel_series"],
        backgroundImageUrl = json["profile"]["background_image_url"],
        twitterAccount = json["profile"]["twitter_account"],
        twitterUrl = json["profile"]["twitter_url"],
        pawooUrl = json["profile"]["pawoo_url"],
        isPremium = json["profile"]["is_premium"],
        isCustomProfileImage = json["profile"]["is_using_custom_profile_image"];
}
