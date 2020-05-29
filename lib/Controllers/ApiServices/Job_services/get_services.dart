import 'dart:convert';
import 'package:autoassit/Controllers/ApiServices/variables.dart';
import 'package:autoassit/Models/servicesModel.dart';
import 'package:http/http.dart' as http;
 
class GetServicesController {
  static const String url = '${URLS.BASE_URL}/proser/getServices';
 
  static Future<List<Service>> getServices() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Service> list = parseServices(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 
  static List<Service> parseServices(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Service>((json) => Service.fromJson(json)).toList();
  }
}