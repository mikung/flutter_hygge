import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class ApiProvider {
  ApiProvider();

  String endPoint01 = 'http://35.247.184.8:4000';

  Future<http.Response> doLogin(String username, String password) async {
    String _url = '$endPoint01/login';
    var body = {'username': username, 'password': password};

    return http.post(_url, body: body);
  }

  Future<http.Response> getProfile(String token) async {
    String _url = '$endPoint01/request/getprofile';

    return http
        .get(_url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  }
}
