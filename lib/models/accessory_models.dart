// accessory_models.dart
class Accessory {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final AccessoryType type;
  final String description;

  Accessory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.type,
    required this.description,
  });
}

enum AccessoryType {
  hat,
  helmet,
  crown,
  cap,
  headband,
}

class AccessoryData {
  static List<Accessory> getAllAccessories() {
    return [
      Accessory(
        id: 'winter_hat',
        name: 'Winter Hat',
        imagePath: 'assets/accessories/winter_hat.png',
        price: 75,
        type: AccessoryType.hat,
        description: 'Winter is coming, Hot Chocolate would be nice',
      ),
      Accessory(
        id: 'fedora_hat',
        name: 'Fedora Hat',
        imagePath: 'assets/accessories/fedora_hat.png',
        price: 200,
        type: AccessoryType.hat,
        description: 'Mafia who in chase right now',
      ),
      Accessory(
        id: 'blue_cap',
        name: 'Blue Capt',
        imagePath: 'assets/accessories/blue_cap.png',
        price: 500,
        type: AccessoryType.cap,
        description: 'Stop the Cap',
      ),
      Accessory(
        id: 'pirate_hat',
        name: 'Pirate Hat',
        imagePath: 'assets/accessories/pirate_hat.png',
        price: 150,
        type: AccessoryType.hat,
        description: 'Adventurous pirate hat for treasure hunting',
      ),
    ];
  }

  static Accessory? getAccessoryById(String id) {
    try {
      return getAllAccessories().firstWhere((accessory) => accessory.id == id);
    } catch (e) {
      return null;
    }
  }
}