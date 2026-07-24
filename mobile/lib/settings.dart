import 'package:shared_preferences/shared_preferences.dart';


class AppSettings {


  static const String _serverIpKey =
      "server_ip";


  static const String _serverPortKey =
      "server_port";



  static Future<void> saveServerConfig({

    required String ip,

    required String port,

  }) async {


    final prefs =
        await SharedPreferences.getInstance();


    await prefs.setString(
      _serverIpKey,
      ip,
    );


    await prefs.setString(
      _serverPortKey,
      port,
    );


  }





  static Future<String?> getServerUrl() async {


    final prefs =
        await SharedPreferences.getInstance();



    final ip =
        prefs.getString(
          _serverIpKey
        );


    final port =
        prefs.getString(
          _serverPortKey
        );



    if (ip == null || port == null) {

      return null;

    }



    return "http://$ip:$port";

  }


}