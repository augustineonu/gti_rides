enum RatingType { none, thumbsUp, thumbsDown }

class RatingItem {
  RatingType selectedType = RatingType.none;
  bool isSelected() {
    return selectedType != RatingType.none;
  }
}

class RatingInfo {
  RatingType ratingType;
  int value;

  RatingInfo(this.ratingType, this.value);
}
