import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String _url = 'http://back-end.e-procurement.abdi.co.id/api/';
  // 192.168.1.2 is my IP, change with your IP address
  // ignore: prefer_typing_uninitialized_variables
  var token;

  auth(data, apiURL) async {
    final String fullUrl = _url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
