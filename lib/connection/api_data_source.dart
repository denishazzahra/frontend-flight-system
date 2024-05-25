import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  static Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    return BaseNetwork.post("users/login", body);
  }

  static Future<Map<String, dynamic>> signup(Map<String, dynamic> body) async {
    return BaseNetwork.post("users/register", body);
  }

  static Future<Map<String, dynamic>> getAirports() async {
    return BaseNetwork.get("airports/");
  }

  static Future<Map<String, dynamic>> getFlights(
      Map<String, dynamic> body) async {
    return BaseNetwork.post("flights/filter", body);
  }

  static Future<Map<String, dynamic>> getUser(String token) async {
    return BaseNetwork.getWithToken("users", token);
  }

  static Future<Map<String, dynamic>> getTickets(String token) async {
    return BaseNetwork.getWithToken("tickets", token);
  }

  static Future<Map<String, dynamic>> bookTicket(
      String token, Map<String, dynamic> body) async {
    return BaseNetwork.postWithToken("tickets/booking", token, body);
  }

  static Future<Map<String, dynamic>> editProfile(
      String token, Map<String, dynamic> body) async {
    return BaseNetwork.putWithToken("users/edit-account", token, body);
  }

  static Future<Map<String, dynamic>> getExchangeRate() async {
    return BaseNetwork.getExchange();
  }
}
