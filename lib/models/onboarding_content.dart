import 'package:gti_rides/styles/asset_manager.dart';

class OnBoardingContent {
  OnBoardingContent(
      {required this.title, required this.description, required this.imageUrl});

  final String title;
  final String description;
  final String imageUrl;

  static List<OnBoardingContent> onBoardingContents = [
    OnBoardingContent(
        title: "Rent any car of your choice",
        description: "Find Your Dream Ride and hit the Road in no time",
        imageUrl: ImageAssets.onboarding_01),
    OnBoardingContent(
        title: "List your car, start earning",
        description:
            "Join our community of Car Owners who are making passive income by renting out their cars to our vetted renters",
        imageUrl: ImageAssets.onboarding_02),
    OnBoardingContent(
        title: "Find Your Dream Ride",
        description:
            "For your glamorous events, GTI has you covered with luxurious cars, so you can hit the road in style and speed.",
        imageUrl: ImageAssets.onboarding03),
  ];
}
