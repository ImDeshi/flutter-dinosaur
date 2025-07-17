// game_state_manager.dart
import 'package:flutter/foundation.dart';
import 'game_storage.dart';
import 'accessory_models.dart';

class GameStateManager extends ChangeNotifier {
  int _coins = 0;
  int _currentScore = 0;
  int _highScore = 0;
  int _lastCoinScore = 0;
  List<String> _ownedAccessories = [];
  String? _equippedAccessory;
  
  // Getters
  int get coins => _coins;
  int get currentScore => _currentScore;
  int get highScore => _highScore;
  List<String> get ownedAccessories => _ownedAccessories;
  String? get equippedAccessory => _equippedAccessory;
  Accessory? get equippedAccessoryData => 
      _equippedAccessory != null ? AccessoryData.getAccessoryById(_equippedAccessory!) : null;

  // Konstanta untuk perhitungan coins
  static const int coinsPerHundredScore = 10;
  static const int scoreThreshold = 100;

  GameStateManager() {
    loadGameData();
  }

  Future<void> loadGameData() async {
    _coins = await GameStorage.getCoins();
    _highScore = await GameStorage.getHighScore();
    _ownedAccessories = await GameStorage.getOwnedAccessories();
    _equippedAccessory = await GameStorage.getEquippedAccessory();
    notifyListeners();
  }

  void updateScore(int newScore) {
    _currentScore = newScore;
    
    // Hitung coins yang diperoleh berdasarkan score
    int currentThreshold = (newScore ~/ scoreThreshold) * scoreThreshold;
    int lastThreshold = (_lastCoinScore ~/ scoreThreshold) * scoreThreshold;
    
    if (currentThreshold > lastThreshold) {
      int coinsEarned = ((currentThreshold - lastThreshold) ~/ scoreThreshold) * coinsPerHundredScore;
      _coins += coinsEarned;
      _lastCoinScore = currentThreshold;
      GameStorage.saveCoins(_coins);
    }
    
    // Update high score jika perlu
    if (newScore > _highScore) {
      _highScore = newScore;
      GameStorage.saveHighScore(_highScore);
    }
    
    notifyListeners();
  }

  void resetGame() {
    _currentScore = 0;
    _lastCoinScore = 0;
    notifyListeners();
  }

  Future<bool> purchaseAccessory(String accessoryId) async {
    final accessory = AccessoryData.getAccessoryById(accessoryId);
    if (accessory == null) return false;
    
    if (_ownedAccessories.contains(accessoryId)) return false;
    
    if (_coins >= accessory.price) {
      _coins -= accessory.price;
      _ownedAccessories.add(accessoryId);
      
      await GameStorage.saveCoins(_coins);
      await GameStorage.saveOwnedAccessories(_ownedAccessories);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> equipAccessory(String? accessoryId) async {
    if (accessoryId == null || _ownedAccessories.contains(accessoryId)) {
      _equippedAccessory = accessoryId;
      await GameStorage.saveEquippedAccessory(accessoryId);
      notifyListeners();
    }
  }

  bool isAccessoryOwned(String accessoryId) {
    return _ownedAccessories.contains(accessoryId);
  }

  bool canAfford(int price) {
    return _coins >= price;
  }

  // Method untuk mendapatkan coins yang akan diperoleh dari score tertentu
  int getCoinsFromScore(int score) {
    return (score ~/ scoreThreshold) * coinsPerHundredScore;
  }

  // Method untuk debugging/testing
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await GameStorage.saveCoins(_coins);
    notifyListeners();
  }

  Future<void> resetAllData() async {
    _coins = 0;
    _currentScore = 0;
    _highScore = 0;
    _lastCoinScore = 0;
    _ownedAccessories.clear();
    _equippedAccessory = null;
    
    await GameStorage.saveCoins(0);
    await GameStorage.saveHighScore(0);
    await GameStorage.saveOwnedAccessories([]);
    await GameStorage.saveEquippedAccessory(null);
    
    notifyListeners();
  }
}