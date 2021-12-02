import 'package:shared_preferences/shared_preferences.dart';

const String keyApiURL = 'API_URL';

class PathFinderLocalProvider {

  Future<String> loadURL() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final url = preferences.getString(keyApiURL);

    if (url != null) {
      return Future.value(url);
    } else {
      throw Exception();
    }
  }

  Future<void> saveURL (url) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString(keyApiURL, url);
  }
}
