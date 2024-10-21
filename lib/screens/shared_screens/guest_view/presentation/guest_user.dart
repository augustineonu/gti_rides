import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/guest/login/login_screen.dart';
import 'package:gti_rides/screens/guest/signup/signup_screen.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class GuesUserView extends StatelessWidget {
  const GuesUserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget(text: "Oops!", style: getBoldStyle(fontSize: 20.sp)),
          SizedBox(
            height: 25.sp,
          ),
          textWidget(
              text: "You need to register or login to access GTi Rides.",
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: getRegularStyle(fontSize: 16.sp)),
          SizedBox(
            height: 24.sp,
          ),
          Center(
            child: GtiButton(
              text: "Create Account",
              onTap: () {
                routeService.offAllNamed(AppLinks.signUp);

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
          ),
          SizedBox(
            height: 15.sp,
          ),
          GtiButton(
            text: "Login",
            // color: pureWhite,
            textColor: white,
            // hasBorder: true,
            // borderColor: ThemeColors.of(context).errorContainer,
            // borderRadius: 12.r,
            onTap: () {
              routeService.offAllNamed(AppLinks.login);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}


//  i have remove token for the below 
// 1.⁠ ⁠all MIS url 
// 2.⁠ ⁠⁠get all cars 
// 3.⁠ ⁠⁠get one car 
// 4.⁠ ⁠⁠get review