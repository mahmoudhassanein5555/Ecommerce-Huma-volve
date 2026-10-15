import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final bool compact;
  final double borderRadius;

  const CustomShimmerCard({
    super.key,
    this.width,
    this.height,
    this.compact = false,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        width: width,
        height: height,
        child: compact ? _buildCompactCard() : _buildProductCard(),
      ),
    );
  }

  Widget _buildCompactCard() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 3, child: _ShimmerBlock(width: double.infinity)),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const _ShimmerBlock(width: double.infinity, height: 14),
                  const SizedBox(height: 8),
                  const _ShimmerBlock(width: 72, height: 12),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _ShimmerBlock(width: 54, height: 18),
                      _ShimmerBlock(
                        width: 28,
                        height: 28,
                        borderRadius: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBlock({
    required this.width,
    this.height = double.infinity,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
