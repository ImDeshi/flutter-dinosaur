// game_ui_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state_manager.dart';
import 'shop_screen.dart';

class GameUIOverlay extends StatelessWidget {
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final bool isGameRunning;

  const GameUIOverlay({
    Key? key,
    this.onPause,
    this.onRestart,
    this.isGameRunning = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Top UI - Score, Coins, Shop Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreDisplay(),
                _buildCoinsDisplay(),
                _buildShopButton(context),
              ],
            ),
            
            Spacer(),
            
            // Bottom UI - Game Controls
            if (!isGameRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGameButton(
                    icon: Icons.refresh,
                    label: 'Restart',
                    onPressed: onRestart,
                  ),
                  _buildGameButton(
                    icon: Icons.shopping_cart,
                    label: 'Shop',
                    onPressed: () => _openShop(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Consumer<GameStateManager>(
      builder: (context, gameState, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SCORE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${gameState.currentScore}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (gameState.highScore > 0)
                Text(
                  'Best: ${gameState.highScore}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinsDisplay() {
    return Consumer<GameStateManager>(
      builder: (context, gameState, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'COINS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${gameState.coins}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _openShop(context),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _openShop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShopScreen()),
    );
  }
}

// Widget untuk menampilkan aksesori yang sedang dipakai di dinosaur
class DinosaurAccessoryWidget extends StatelessWidget {
  final double dinosaurWidth;
  final double dinosaurHeight;
  final Offset dinosaurPosition;

  const DinosaurAccessoryWidget({
    Key? key,
    required this.dinosaurWidth,
    required this.dinosaurHeight,
    required this.dinosaurPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateManager>(
      builder: (context, gameState, child) {
        final accessory = gameState.equippedAccessoryData;
        if (accessory == null) return SizedBox.shrink();

        return Positioned(
          left: dinosaurPosition.dx + (dinosaurWidth * 0.1), // Posisi relatif ke kepala dinosaur
          top: dinosaurPosition.dy - (dinosaurHeight * 0.3), // Di atas kepala dinosaur
          child: Image.asset(
            accessory.imagePath,
            width: dinosaurWidth * 0.8,
            height: dinosaurHeight * 0.6,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

// Widget untuk menampilkan progress coins
class CoinsProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateManager>(
      builder: (context, gameState, child) {
        final currentScore = gameState.currentScore;
        final nextCoinScore = ((currentScore ~/ 100) + 1) * 100;
        final progress = (currentScore % 100) / 100.0;
        final coinsFromCurrentScore = gameState.getCoinsFromScore(currentScore);

        return Container(
          margin: EdgeInsets.only(top: 70),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Next coin at ${nextCoinScore}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: 120,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                chil