import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/get_it.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/custom_shimmer_card.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_states.dart';
import '../../domain/entities/category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_states.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_states.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

// The greeting header is approx 204px high and the chip row is 64px (268px total).
// The sticky black bar starts fading/sliding in at 140px and fully locks at 200px.
// At offset 206px, the old chip row is completely hidden under the 54px black bar,
// and the product grid starts right below the black bar with a clean 8px gap.
const double _kStickyStart = 140.0;
const double _kStickyRange = 60.0;
const double _kDockedOffset = 206.0;
// Heights
const double _kChipsRowHeight = 44.0;
const double _kStickyBarHeight = 54.0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CategoryCubit>()),
        BlocProvider(create: (_) => getIt<ProductCubit>()..loadProducts()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedCategoryId;
  bool _allCategoriesSelected = true;
  bool _keepBlackBarVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<ProductCubit>().loadMore();
    }

    // Only release the sticky bar hold if the user intentionally scrolls back up
    if (_keepBlackBarVisible &&
        _scrollController.hasClients &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollController.offset < _kStickyStart) {
      setState(() {
        _keepBlackBarVisible = false;
      });
    }
  }

  void _scrollToDocked() {
    if (!_scrollController.hasClients) return;
    final current = _scrollController.offset;
    if ((current - _kDockedOffset).abs() < 2.0) return;

    if (current > _kDockedOffset + 400) {
      _scrollController.jumpTo(_kDockedOffset);
    } else {
      _scrollController.animateTo(
        _kDockedOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _selectAll({bool fromSticky = false}) {
    setState(() {
      _allCategoriesSelected = true;
      _selectedCategoryId = null;
      if (fromSticky) {
        _keepBlackBarVisible = true;
      }
    });
    if (fromSticky) {
      _scrollToDocked();
    }
    context.read<ProductCubit>().loadProducts();
  }

  void _selectCategory(Category cat, {bool fromSticky = false}) {
    setState(() {
      _allCategoriesSelected = false;
      _selectedCategoryId = cat.id;
      if (fromSticky) {
        _keepBlackBarVisible = true;
      }
    });
    if (fromSticky) {
      _scrollToDocked();
    }
    context.read<ProductCubit>().loadProducts(categoryId: cat.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // Stack so the sticky overlay sits on top of the scroll view
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Greeting
                SliverToBoxAdapter(child: _GreetingHeader()),

                // Category chip row (scrolls away naturally)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: SizedBox(
                      height: _kChipsRowHeight,
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading ||
                              state is CategoryInitial) {
                            return _shimmerChips();
                          }
                          if (state is CategoryError) {
                            return Center(
                              child: TextButton(
                                onPressed: context
                                    .read<CategoryCubit>()
                                    .loadCategories,
                                child:
                                    const Text('Could not load. Retry'),
                              ),
                            );
                          }
                          final cats =
                              (state as CategoryLoaded).categories;
                          return _buildChipList(cats);
                        },
                      ),
                    ),
                  ),
                ),

                // Product grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductsInitial ||
                          state is ProductsLoading) {
                        return _loadingGrid();
                      }
                      if (state is ProductsError) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.message,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<ProductCubit>()
                                        .loadProducts(
                                          categoryId: _selectedCategoryId,
                                        ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      final loaded = state as ProductsLoaded;
                      if (loaded.products.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 48,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 56,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No products found in this category.',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      final hasFooter = loaded.isLoadingMore ||
                          loaded.loadMoreError != null;
                      return SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == loaded.products.length) {
                              if (loaded.isLoadingMore) {
                                return const CustomShimmerCard();
                              }
                              return Center(
                                child: TextButton(
                                  onPressed: context
                                      .read<ProductCubit>()
                                      .loadMore,
                                  child: const Text(
                                    'Could not load more. Retry',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return ProductCard(
                                product: loaded.products[index]);
                          },
                          childCount: loaded.products.length +
                              (hasFooter ? 1 : 0),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: _kDockedOffset + 48),
                ),
              ],
            ),
          ),

          // ── Sticky black tab bar overlay ───────────────────────────────
          // AnimatedBuilder drives animation directly from the scroll
          // controller — no setState on every frame.
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, catState) {
              if (catState is! CategoryLoaded) {
                return const SizedBox.shrink();
              }
              final cats = catState.categories;
              return AnimatedBuilder(
                animation: _scrollController,
                builder: (context, _) {
                  final offset = _scrollController.hasClients
                      ? _scrollController.offset
                      : 0.0;
                  final raw = _keepBlackBarVisible
                      ? 1.0
                      : ((offset - _kStickyStart) / _kStickyRange)
                          .clamp(0.0, 1.0);
                  final t = Curves.easeInOutCubic.transform(raw);

                  if (t == 0) return const SizedBox.shrink();

                  return SafeArea(
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: t, // clips the bar while it slides in
                        child: Opacity(
                          opacity: t,
                          child: _StickyBlackBar(
                            categories: cats,
                            allSelected: _allCategoriesSelected,
                            selectedCategoryId: _selectedCategoryId,
                            onSelectAll: () => _selectAll(fromSticky: true),
                            onSelectCategory: (cat) =>
                                _selectCategory(cat, fromSticky: true),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _shimmerChips() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (_, _) => const CustomShimmerCard(
        compact: true,
        width: 88,
        height: 44,
        borderRadius: 24,
      ),
    );
  }

  Widget _buildChipList(List<Category> cats) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: cats.length + 1,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return CategoryChip(
            label: 'All',
            isSelected: _allCategoriesSelected,
            onTap: () => _selectAll(fromSticky: false),
          );
        }
        final cat = cats[index - 1];
        return CategoryChip(
          label: cat.name,
          isSelected:
              !_allCategoriesSelected && _selectedCategoryId == cat.id,
          onTap: () => _selectCategory(cat, fromSticky: false),
        );
      },
    );
  }

  SliverGrid _loadingGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, _) => const CustomShimmerCard(),
        childCount: 8,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sticky black pill tab bar
// ══════════════════════════════════════════════════════════════════════════════
class _StickyBlackBar extends StatelessWidget {
  final List<Category> categories;
  final bool allSelected;
  final int? selectedCategoryId;
  final VoidCallback onSelectAll;
  final ValueChanged<Category> onSelectCategory;

  const _StickyBlackBar({
    required this.categories,
    required this.allSelected,
    required this.selectedCategoryId,
    required this.onSelectAll,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kStickyBarHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 28),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _TabItem(
              label: 'All',
              isSelected: allSelected,
              onTap: onSelectAll,
            );
          }
          final cat = categories[index - 1];
          return _TabItem(
            label: cat.name,
            isSelected: !allSelected && selectedCategoryId == cat.id,
            onTap: () => onSelectCategory(cat),
          );
        },
      ),
    );
  }
}

// ── Single tab label with animated underline ─────────────────────────────────
class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.white70,
              letterSpacing: isSelected ? 0.4 : 0,
            ),
            child: Text(label),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 2,
            width: isSelected ? 18 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Greeting header (extracted widget so the builder above stays clean)
// ══════════════════════════════════════════════════════════════════════════════
class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu, color: AppTheme.primary),
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String? avatarUrl;
                  if (state is ProfileSuccess &&
                      state.user.avatar.isNotEmpty) {
                    avatarUrl = state.user.avatar;
                  }
                  return CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    onBackgroundImageError:
                        avatarUrl != null ? (_, _) {} : null,
                    child: avatarUrl == null
                        ? (state is ProfileLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primary,
                                ),
                              )
                            : const Icon(Icons.person,
                                color: AppTheme.primary))
                        : null,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Explore',
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 8),
          Text(
            'Best trendy collection!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
