import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rate;

  const RatingStars({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rate >= starValue) {
          icon = Icons.star;
        } else if (rate >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(
          icon,
          size: 16,
          color: const Color(0xFF02C1D3),
        );
      }),
    );
  }
}
