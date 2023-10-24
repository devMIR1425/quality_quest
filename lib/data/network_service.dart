
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quality_quest/core/params/apis.dart';
import 'dart:convert';
import 'package:quality_quest/data/dio_interseptor.dart';
import 'package:quality_quest/data/store.dart';
import 'package:quality_quest/domain/model/screens/category_model/category_model.dart';


// abstract class Network {
// Future<void> methodPost({required String api,required Map<String, Object?> data});
// static Future<void> _saveToken(Map<String,dynamic> data);
// static Future<bool> methodSignUpPost({required String api,required Map<String, Object?> data});
// static Future<bool> methodSignInPost({required String api, required Map<String, Object?> data});
// }

final dio = Dio();

class HttpService {
  late final Dio _dio;

  HttpService() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

  // #Save Token
  static Future<void> _saveToken(Map<String, dynamic> data) async {
    final token = data["accessToken"];
    final refToken = data["refreshToken"];
    print("AccessToken:-----------------$token----------------------");
    print("RefreshToken:-----------------$refToken----------------------");
    await Store.setToken(token, refToken);
  }

  // #Method SignUp
  static Future<bool> methodSignUpPost({
    required String api,
    required Map<String, Object?> data,
  }) async {
    try {
      final response = await dio.post("${Api.baseUrl}$api", data: data);
      print("-----------------${response.statusCode}----------------------");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("SIGN UP ERROR:===>$e");
    }
    return false;
  }

  // #Method SignIn
  static Future<bool> methodSignInPost({required String api, required Map<String, Object?> data}) async {
    try {
      final response = await dio.post(
        "${Api.baseUrl}$api",
        data: jsonEncode(data),
      );
      print("-----------------${response.statusCode}----------------------");
      print("-----------------${response.data}----------------------");
      if (response.statusCode == 200 || response.statusCode == 201) {
        _saveToken(response.data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("SIGN IN ERROR:===>$e");
    }
    return false;
  }

  // #Method GET Science Type

  static Future<List<ScienceType>> fetchScienceTypes({
    required String api,
  }) async {
    final response = await dio.get("${Api.baseUrl}$api");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List jsonList = response.data;
       final data = jsonList.map((json) => ScienceType.fromJson(json as Map<String, Object?>)).toList();
      return data;
    } else {
      throw Exception('Failed to fetch science types');
    }
  }

  // #Method Logo0ut
  static Future<bool> logoOut() async {
    try {
      await Store.clear();
      return true;
    } catch (e) {
      print("Error:----------$e-----------");
    }
    return false;
  }

  static Future<bool> createScience({required String api, required Map<String, Object?> data})async{
    try {
      final response = await dio.post("${Api.baseUrl}$api", data: data);
      print("-----------------${response.statusCode}----------------------");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("SIGN UP ERROR:===>$e");
    }
    return false;
  }

}
