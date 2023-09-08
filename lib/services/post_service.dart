import 'dart:convert';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/post.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:http/http.dart' as http;

// Index Post
Future<ApiResponse> getPost() async{

  ApiResponse apiResponse = ApiResponse();

  try{
   String token = await getToken();

   final response = await http.get(

   Uri.parse(postsURL),
   headers: {
     'Accept' : 'application/json',
     'Content-Type': 'application/json',
     'Authorization' : 'Bearer $token'
   });

   //print(jsonDecode(response.body)['posts'].map((p) => p));

   switch(jsonDecode(response.body)['status']){
     case 200:
       final decodeJson = jsonDecode(response.body)['posts'].toList();
       apiResponse.data = decodeJson;
       apiResponse.data as List<dynamic>;
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

// Create Post
Future<ApiResponse> createPost(String body, String? image) async{
  print(image);
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
       Uri.parse(postsURL),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: image != null ?
        {
          'body':body,
          'image': image,
        }
        :
        {
         'body': body
        }
    );

    switch(jsonDecode(response.body)['status']){
      case 200:
        apiResponse.data = jsonDecode(response.body)['post'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

// Update Post
Future<ApiResponse> updatePost(int postId, String body) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(
        Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'body': body
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
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

// Delete Post
Future<ApiResponse> deletePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.delete(
        Uri.parse('$postsURL/$postId'),
        headers: {
          'Accpet' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
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

// Like or unLike post
Future<ApiResponse> likeUnlikePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$postsURL/$postId/likes'),
      headers: {
        'Accept' : 'application/json',
        'Authorization': 'Bearer $token'
      });

    jsonDecode(response.body);

    switch(jsonDecode(response.body)['status']){
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
