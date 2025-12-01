class ReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final String date;
  final double rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.date,
    required this.rating,
    required this.comment,
  });
}