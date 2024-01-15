  // Future<dynamic> postRequest({
  //   required String endpoint,
  //   Map? data,
  //   String? token,
  // }) async {
  //   try {
  //     logger.log("POST REQUEST DATA:: $data");
  //     late Response response;
  //     response = await _dio.post(
  //       endpoint,
  //       data: data,
  //       options: Options(
  //         headers: {
  //           'Authorization':
  //               'Bearer ${token ?? tokenService.accessToken.value}',
  //         },
  //       ),
  //     );
  //     logger.log("POST REQUEST RESPONSE:: $response");
  //     final ApiResponseModel apiResponse =
  //         ApiResponseModel.fromJson(response.data);
  //     if (!endpoint.contains('auth')) {
  //       if (!apiResponse.status || apiResponse.statusCode == 401) {
  //         bool newAccessTokenResult = await tokenService.getNewAccessToken();
  //         logger.log("HELLLL");
  //         if (!newAccessTokenResult) {
  //           logger.log("HELLLL22");
  //           logger.log('Going to welcome screen');
  //           routeService.offAllNamed(AppLinks.welcomeBack);
  //           return;
  //         }
  //         response = await _dio.post(
  //           endpoint,
  //           data: data,
  //           options: Options(
  //             headers: {
  //               'Authorization':
  //                   'Bearer ${token ?? tokenService.accessToken.value}',
  //             },
  //           ),
  //         );
  //       } else if (apiResponse.statusCode == 403) {
  //         logger.log('Going to login screen');
  //         logger.log("HELLLL33");
  //         _logOut();
  //         return;
  //       }
  //     }
  //     return response.data;
  //   } on DioException catch (e) {
  //     logger.log("POST REQUEST ERROR ($endpoint) :: ${e.response?.data}");
  //     if (e.response?.data != null) {
  //       return e.response?.data;
  //     }
  //     throw "An error occurred";
  //   } on SocketException {
  //     throw "seems you are offline";
  //   } catch (error) {
  //     throw error.toString();
  //   }
  // }

  