import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mr_candy/core/apis/end_point.dart';

import 'package:mr_candy/core/failure.dart';

import 'package:mr_candy/features/login/data/models/user_model.dart';

import 'login_repo.dart';
import 'package:http/http.dart'as http;

class LoginRepoImplementation implements LoginRepo{
  @override
  Future<Either<Failure, UserModel>> login({required String email, required String password})async {

  try{
    var result = await http.post(
        Uri.parse(EndPoints.baseUrl=EndPoints.login),
        body:
        {
          "email": email,
          "password": password

        }
    );
    var body= jsonDecode(result.body);
    if(body["status"]){

      return right(UserModel(id: body["data"]["id"], name: body["data"]["name"], email: body["data"]["email"], phone: body["data"]["phone"], image: body["data"]["image"], points: body["data"]["points"], credit: body["data"]["credit"], token: body["data"]["token"]));
    }else{
      return left(ApiFailure(message: body["message"]));

    }



  }on SocketException{
    return left(NoInternetFailure(message: "No Internet Failure"));
  }
  catch(e){
    return left(ApiFailure(message: "Error"));
  }
  }
  
}