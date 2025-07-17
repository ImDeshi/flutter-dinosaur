import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameStorage {
  static const String _coinsKey = 'game_coins';
  static const String _accessoriesKey = 'owned_accessories';
  static const String _equippedAccessoryKey = 'equipped_accessory';
  static const String _highScoreKey = 'high_score';

  static Future<void> saveCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, coins);
  }

  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  static Future<void> saveOwnedAccessories(List<String> accessories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_accessoriesKey, accessories);
  }

  static Future<List<String>> getOwnedAccessories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_accessoriesKey) ?? [];
  }

  static Future<void> saveEquippedAccessory(String? accessoryId) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessoryId != null) {
      await prefs.setString(_equippedAccessoryKey, accessoryId);
    } else {
      await prefs.remove(_equippedAccessoryKey);
    }
  }

  static Future<String?> getEquippedAccessory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_equippedAccessoryKey);
  }

  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  static Future<void> addCoins(int amount) async {
    final currentCoins = await getCoins();
    await saveCoins(currentCoins + amount);
  }

  static Future<bool> spendCoins(int amount) async {
    final currentCoins = await getCoins();
    if (currentCoins >= amount) {
      await saveCoins(currentCoins - amount);
      return true;
    }
    return false;
  }

  static Future<void> purchaseAccessory(String accessoryId) async {
    final owned = await getOwnedAccessories();
    if (!owned.contains(accessoryId)) {
      owned.add(accessoryId);
      await saveOwnedAccessories(owned);
    }
  }
}