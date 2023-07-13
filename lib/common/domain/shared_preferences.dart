import 'package:shared_preferences/shared_preferences.dart';

class RevisionProvider {
  final String _revision = 'revision';
  final _sharedPreferences = SharedPreferences.getInstance();
  Future<int> loadValue() async {
    final revision = (await _sharedPreferences).getInt(_revision) ?? -1;
    return revision;
  }

  Future<void> saveValue(int revision) async {
    (await _sharedPreferences).setInt(_revision, revision);
  }
}
