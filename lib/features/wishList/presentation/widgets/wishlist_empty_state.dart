import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/primary_button.dart';

class WishlistEmptyState extends StatelessWidget {
  final VoidCallback? onExplorePressed;
  final String title;
  final String subtitle;

  const WishlistEmptyState({
    super.key,
    this.onExplorePressed,
    this.title = 'Your Wishlist is Empty',
    this.subtitle =
        'Explore our curated collection and save items you love to find them easily anytime.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (onExplorePressed != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Explore Products',
                onPressed: onExplorePressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
