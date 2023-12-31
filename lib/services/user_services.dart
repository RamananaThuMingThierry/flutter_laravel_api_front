import 'dart:convert';
import 'dart:io';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/user.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/** Login **/
Future<ApiResponse> login(String email, String password) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
      apiResponse.error = serverError;
  }

  return apiResponse;
}

/** Register **/
Future<ApiResponse> register(String name, String email, String password) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

/** User **/
Future<ApiResponse> getUserDetails() async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(jsonDecode(response.body)['status']){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

/** Update User **/
Future<ApiResponse> updateUser(String name, String? image) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      body: image == null ?{
          'name' : name,
      } : {
          'name': name,
          'image' : image
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

/** Get Token **/
Future<String> getToken() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

/** Get User id **/
Future<int> getUserId() async{
  ApiResponse apiResponse = ApiResponse();
  int? userId;
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse(userIdURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    userId = jsonDecode(response.body)['userId'];
  }catch(e){
    apiResponse.error = serverError;
  }
  return userId!;
}


/** Logout **/
Future<bool> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file){
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}