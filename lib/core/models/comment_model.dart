class Comment {
  final int id;
  final String comment;
  final int userId;
  final String userName;
  final String userProfilePic;

  Comment({
    required this.id,
    required this.comment,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'],
      userId: json['user']['id'],
      userName: json['user']['name'],
      userProfilePic: json['user']['profile_pic'],
    );
  }
}
