import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';

import '../../../../../core/dummy_data.dart';
import '../../../../../core/theme.dart';
import '../../cubit/home_cubit.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onListen);
  }

  void _onListen() {
    if (!_scrollController.hasClients) return;
    const triggerDistance = 200;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - triggerDistance) {
      _homeCubit.loadProductsMore(_homeCubit.categoryId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) {
        _homeCubit = getIt<HomeCubit>();
        _homeCubit.loadHome();
        return _homeCubit;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                            child: const Icon(
                              Icons.menu,
                              color: AppTheme.primary,
                            ),
                          ),
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              dummyUser.profilePictureUrl,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Explore',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Best trendy collection!',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search clothes...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) {
                          if (current is HomeProductsLoadingState ||
                              current is HomeProductsSuccessState ||
                              current is HomeProductsFailureState) {
                            return false;
                          }
                          return true;
                        },

                        builder: (context, state) {
                          if (state is HomeLoadingState ||
                              state is HomeInitial) {
                            return const SizedBox(
                              height: 44,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primary,
                                ),
                              ),
                            );
                          }
                          if (state is HomeFailureState) {
                            return SizedBox(
                              height: 44,
                              child: Center(
                                child: Text('Error: ${state.errorMessage}'),
                              ),
                            );
                          }
                          if (state is CategorySuccess) {
                            final categories = state.categoryList;
                            return SizedBox(
                              height: 44,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) => CategoryChip(
                                  label: categories[index].name ?? 'Unknown',
                                  isSelected:
                                      categories[index].id ==
                                      context.read<HomeCubit>().categoryId,
                                  onTap: () => context
                                      .read<HomeCubit>()
                                      .getProducts(categories[index].id),
                                ),
                              ),
                            );
                          }
                          return const SizedBox(height: 44);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadingState ||
                      state is HomeInitial ||
                      state is HomeProductsLoadingState) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      ),
                    );
                  }
                  if (state is HomeFailureState) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: ${state.errorMessage}'),
                      ),
                    );
                  }
                  if (state is HomeProductsFailureState) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: ${state.errorMessage}'),
                      ),
                    );
                  }
                  if (state is HomeProductsSuccessState) {
                    final products = state.productList;
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= products.length) {
                              if (state.loadMoreError != null) {
                                return Center(
                                  child: Text(state.loadMoreError!),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primary,
                                ),
                              );
                            }
                            return ProductCard(product: products[index]);
                          },
                          childCount:
                              products.length +
                              (state.isLoadingMore ||
                                      state.loadMoreError != null
                                  ? 1
                                  : 0),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeProductsLoadingState) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
