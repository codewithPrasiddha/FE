import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String baseUrl = 'http://127.0.0.1:8000/api/v1/';
  Future<http.Response> postData(data, apiUrl) async {
    var token = await _getToken();
    var fullUrl = baseUrl + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders(token));
  }

  Future<http.Response> deleteData(apiUrl, token) async {
    var fullUrl = baseUrl + apiUrl;
    return await http.delete(fullUrl, headers: _setHeaders(token));
  }

  Future<http.Response> postDataWithoutToken(data, apiUrl) async {
    var fullUrl = baseUrl + apiUrl;
    return await http.post(fullUrl, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  Future<http.Response> postDataWithToken(data, apiUrl, token) async {
    var fullUrl = baseUrl + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders(token));
  }

  Future<http.Response> editData(data, apiUrl, token) async {
    var fullUrl = baseUrl + apiUrl;
    return await http.put(fullUrl,
        body: jsonEncode(data), headers: _setHeaders(token));
  }

  Future<http.Response> getData(apiUrl) async {
    var token = await _getToken();

    var fullUrl = baseUrl + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders(token));
  }

  Future<http.Response> getGet(apiUrl, token) async {
    var fullUrl = baseUrl + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders(token));
  }

  Future<http.Response> getDataWithoutToken(apiUrl) async {
//    var token = await _getToken();

    var fullUrl = baseUrl + apiUrl;
    return await http.get(
      fullUrl,
    );
  }

  Future<http.Response> getMedicine() async {
    return await http.get(
        'https://dailymed.nlm.nih.gov/dailymed/services/v2/drugnames.json',
        headers: {
          'Content-type': 'application/json',
        });
  }

  _setHeaders(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token ' + token
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }

  _getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    return json.decode(user);
  }

  Future<http.Response> getChatData() async {
    var fullUrl = "http://localhost:3000/chats";
    return await http.get(
      fullUrl,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }
}
