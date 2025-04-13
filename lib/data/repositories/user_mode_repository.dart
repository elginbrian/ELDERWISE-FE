import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModeRepository {
  static const String _userModeKey = 'user_mode';

  Future<void> setUserMode(UserMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userModeKey, mode.toString().split('.').last);
  }

  Future<UserMode> getUserMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString(_userModeKey);

    if (modeString == null) {
      return UserMode.caregiver;
    }

    return UserMode.fromString(modeString);
  }
}
