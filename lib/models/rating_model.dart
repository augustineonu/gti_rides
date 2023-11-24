class RatingItem {
  String rating;
  RatingType selectedType;

  RatingItem({required this.rating, this.selectedType = RatingType.none});
}

enum RatingType { none, thumbsUp, thumbsDown }
