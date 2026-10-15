import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';
import '../widgets/wishlist_empty_state.dart';
import '../widgets/wishlist_error_widget.dart';
import '../widgets/wishlist_item_card.dart';
import '../widgets/wishlist_loading_skeleton.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.hasClients && _scrollController.offset > 10;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = _isScrolled ? 48.0 : 60.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          height: topPadding + appBarHeight,
          decoration: BoxDecoration(
            color: _isScrolled ? Colors.black : AppTheme.background,
            borderRadius: _isScrolled
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  )
                : BorderRadius.zero,
            boxShadow: _isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const SizedBox(width: 8),
                if (Navigator.canPop(context))
                  IconButton(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isScrolled
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: _isScrolled
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                ),
                              ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: _isScrolled ? Colors.white : Colors.black87,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold,
                        fontSize: _isScrolled ? 18 : 21,
                        color: _isScrolled ? Colors.white : AppTheme.primary,
                      ),
                      child: const Text('My Wishlist'),
                    ),
                  ),
                ),
                BlocBuilder<WishlistCubit, WishlistState>(
                  builder: (context, state) {
                    final cubit = context.read<WishlistCubit>();
                    if (cubit.wishlistProducts.isEmpty) {
                      return const SizedBox(width: 56);
                    }
                    return IconButton(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isScrolled
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: _isScrolled
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                        ),
                        child: const Icon(
                          Icons.delete_sweep_outlined,
                          size: 20,
                          color: AppTheme.accent,
                        ),
                      ),
                      tooltip: 'Clear Wishlist',
                      onPressed: () => _confirmClear(context),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state is WishlistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.accent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<WishlistCubit>();

          // 1. Loading state with no cached items
          if (state is WishlistLoading && cubit.wishlistProducts.isEmpty) {
            return const WishlistLoadingSkeleton();
          }

          // 2. Error state with no cached items
          if (state is WishlistError && cubit.wishlistProducts.isEmpty) {
            return WishlistErrorWidget(
              message: state.message,
              onRetry: () => context.read<WishlistCubit>().loadWishlist(),
            );
          }

          // 3. Empty state
          if (cubit.wishlistProducts.isEmpty) {
            return WishlistEmptyState(
              onExplorePressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }

          // 4. Loaded state (with pull-to-refresh)
          final items = cubit.wishlistProducts;
          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () => context.read<WishlistCubit>().loadWishlist(),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${items.length} ${items.length == 1 ? 'item' : 'items'} saved',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _confirmClear(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear all',
                          style: TextStyle(
                            color: AppTheme.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return WishlistItemCard(product: product);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Wishlist?'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<WishlistCubit>().clearWishlist();
              Navigator.pop(dialogContext);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
