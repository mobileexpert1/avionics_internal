import 'package:flutter/material.dart';

import 'StickerModel.dart';

class StickerCard extends StatelessWidget {
  final StickerModel sticker;
  final VoidCallback? onTap;

  const StickerCard({super.key, required this.sticker, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: _buildImage(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sticker.brand,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff23235B),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      sticker.model,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff23235B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (sticker.isUnlocked) {
      return Image.network(
        sticker.imageUrl ?? '',
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return Container(
      color: const Color(0xffE5E5E5),
      child: Center(
        child: Icon(
          Icons.airplanemode_active,
          size: 60,
          color: Colors.white.withOpacity(.8),
        ),
      ),
    );
  }
}
