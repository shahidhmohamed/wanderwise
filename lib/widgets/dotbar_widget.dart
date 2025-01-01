import 'package:flutter/material.dart';

class DotBar extends StatelessWidget {
  final double rating;  // Rating value (1.0 to 5.0)
  final int totalDots;  // Total number of dots (usually 5)

  const DotBar({
    super.key,
    required this.rating,
    this.totalDots = 5,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the number of filled dots based on the rating
    int filledDots = (rating / 5 * totalDots).round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalDots, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            index < filledDots ? Icons.circle : Icons.circle_outlined,
            size: 18.0,
            color: index < filledDots ? Colors.green : Colors.grey,
          ),
        );
      }),
    );
  }
}
