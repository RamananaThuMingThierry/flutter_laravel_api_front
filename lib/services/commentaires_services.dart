import 'dart:convert';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/commentaires.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getCommentaires(int postId)async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$postsURL/$postId/commentaires'),
        headers: {
          'Accpet' : 'application/json',
          'Authorization' : 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['Commentaires'].map((p) => Commentaires.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
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

// Create Commentaires
Future<ApiResponse> createCommentaires(int postId, String? commentaires) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$postsURL/$postId/commentaires'),
        headers: {
          'Accpet' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'commentaires': commentaires
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

// Delete Commentaires
Future<ApiResponse> deleteCommentaires(int commentairesId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.delete(
        Uri.parse('$commentairesURL/$commentairesId'),
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

// Edit Commentaires
Future<ApiResponse> updateCommentaires(int commentaireId, String? commentaires) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(
        Uri.parse('$commentairesURL/$commentaireId'),
        headers: {
          'Accpet' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'commentaires': commentaires
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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
