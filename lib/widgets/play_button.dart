import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const PlayButton({super.key, required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPlaying ? Colors.redAccent : Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
            )
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
