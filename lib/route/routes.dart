import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/car%20owner/owner_landing_page.dart';
import 'package:gti_rides/screens/car%20renter/home/choose_trip_date/choose_trip_date_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_city/search_city_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/car_selection_result_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/kyc_check/kyc_check_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/payment_summary/payment_summary_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/update_kyc/update_kyc_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/view_car/view_car.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/reviews/review_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/search_filter/search_filter_screen.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/search_result_screen.dart';
import 'package:gti_rides/screens/car%20renter/landing_page.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_details_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/change_password/change_password_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/email/email_imput_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/email/email_verification.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/phone/phone_input_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/phone/phone_verification.dart';
import 'package:gti_rides/screens/car%20renter/more/favorite/favorite_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/identity_verification.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/emergency_contact_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/gender_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/home_address_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/occupation_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/office_address_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/proof_of_identity.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/screens/referral_code_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/more_screen.dart';
import 'package:gti_rides/screens/car%20renter/more/profile/profile_screen.dart';
import 'package:gti_rides/screens/car%20renter/trips/choose_single_trip_date/choose_single_trip_date_screen.dart';
import 'package:gti_rides/screens/guest/Reset_password/request_reset_password_screen.dart';
import 'package:gti_rides/screens/guest/login/login_screen.dart';
import 'package:gti_rides/screens/guest/onboarding/onboarding_screen.dart';
import 'package:gti_rides/screens/guest/otp_verification/otp_verification.dart';
import 'package:gti_rides/screens/guest/signup/signup_screen.dart';
import 'package:gti_rides/screens/guest/splash/splash_screen.dart';

import '../screens/guest/Reset_password/reset_password_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: AppLinks.splash,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
        name: AppLinks.onboarding,
        page: () => const OnboardingScreen(),
        binding: OnboardingScreenBinding(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: AppLinks.login,
        page: () => const LoginScreen(),
        binding: LoginScreenBinding(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
      name: AppLinks.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpScreenBinding(),
    ),
    GetPage(
      name: AppLinks.verifyOtp,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: AppLinks.requestResetPassword,
      page: () => const RequestResetPasswordScreen(),
      binding: RequestResetPasswordBinding(),
    ),
    GetPage(
      name: AppLinks.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppLinks.carRenterLanding,
      page: () => const RenterLandingPage(),
      // binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppLinks.searchCity,
      page: () => const SearchCityScreen(),
      binding: SearchCityBinding(),
    ),
    GetPage(
      name: AppLinks.chooseTripDate,
      page: () => const ChooseTripDateScreen(),
      binding: ChooseTripDateBinding(),
    ),
    GetPage(
      name: AppLinks.searchResult,
      page: () => const SearchResultScreen(),
      binding: SearchResultBinding(),
    ),
    GetPage(
      name: AppLinks.searchFilter,
      page: () => const SearchFilterScreen(),
      binding: SearchFilterBinding(),
    ),
    GetPage(
      name: AppLinks.carSelectionResult,
      page: () => const CarSelectionResultScreen(),
      binding: CarSelectionResultBinding(),
    ),
    GetPage(
      name: AppLinks.reviews,
      page: () => const ReviewsScreen(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: AppLinks.viewCar,
      page: () => const ViewCarScreen(),
      binding: ViewCarBinding(),
    ),
    GetPage(
      name: AppLinks.kycCheck,
      page: () => const KycCheckScreen(),
      binding: KycCheckBinding(),
    ),
    GetPage(
      name: AppLinks.updateKyc,
      page: () => const UpdateKycScreen(),
      binding: UpdateKycBinding(),
    ),
    GetPage(
      name: AppLinks.paymentSummary,
      page: () => const PaymentSummaryScreen(),
      binding: PaymentSummaryBinding(),
    ),
    GetPage(
      name: AppLinks.more,
      page: () => const MoreScreen(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: AppLinks.chooseSingleDateTrip,
      page: () => const ChooseSingleDateTripScreen(),
      binding: ChooseSingleDateTripBinding(),
    ),
    GetPage(
      name: AppLinks.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppLinks.favorite,
      page: () => const FavoriteScreen(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: AppLinks.accountDetails,
      page: () => const AccountDetailsScreen(),
      binding: AccountDetailsBinding(),
    ),
    GetPage(
      name: AppLinks.email,
      page: () => const EmailScreen(),
    ),
    GetPage(
      name: AppLinks.emailOtp,
      page: () => const EmailVerificationScreen(),
    ),
    GetPage(
      name: AppLinks.phoneInput,
      page: () => const PhoneInputScreen(),
    ),
    GetPage(
      name: AppLinks.phoneOtp,
      page: () => const PhoneVerificationScreen(),
    ),
    GetPage(
      name: AppLinks.changePassword,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: AppLinks.identityVerification,
      page: () => const IdentityVerificationScreen(),
      binding: IdentityVerifiationBinding(),
    ),
    GetPage(
      name: AppLinks.proofOfIdentity,
      page: () => const ProofOfIdentityScreen(),
    ),
    GetPage(
      name: AppLinks.homeAddress,
      page: () => const HomeAddressScreen(),
    ),
    GetPage(
      name: AppLinks.officeAddress,
      page: () => const OfficeAddressScreen(),
    ),
    GetPage(
      name: AppLinks.emergencyContact,
      page: () => const EmergencyContactScreen(),
    ),
    GetPage(
      name: AppLinks.occupation,
      page: () => const OccupationScreen(),
    ),
    GetPage(
      name: AppLinks.gender,
      page: () => const GenderScreen(),
    ),
    GetPage(
      name: AppLinks.referral,
      page: () => const ReferralCodeScreen(),
    ),
    GetPage(
      name: AppLinks.carOwnerLanding,
      page: () => const OwnerLandingPage(),
    ),
    GetPage(
      name: AppLinks.carRenterLanding,
      page: () => const RenterLandingPage(),
    ),
  ];
}
