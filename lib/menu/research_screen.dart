import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/menu/bottom_nav.dart';
import 'package:present_group2/screen/main_screen.dart';
import 'package:present_group2/screen/product_detail_screen.dart';
import 'package:present_group2/menu/older_sceen.dart';
import 'package:present_group2/menu/profile_screen.dart';

// 👉 Change this to whichever picture you want on the "You'll Love These"
// banner — just swap the filename below (it must already exist in your
// lib/image/ folder). Nothing else in the file needs to change.
const String kRecommendBannerImage = 'lib/image/model1.jpg';

// 👉 Change the picture shown for each brand in "Featured brands" here —
// just edit the file path on the right. Every brand listed here always
// shows up, even before any product uses that brand name. A brand that
// isn't listed here still shows up if a product uses it, falling back to
// a photo from one of its own products.
const Map<String, String> kFeaturedBrandImages = {
  'Zara': 'lib/image/logo1.jpg',
  'Dipstore': 'lib/image/logo2.jpg',
  'Fashion Nova': 'lib/image/logo3.jpg',
  'Vector': 'lib/image/logo4.jpg',
  'Angkor Fashion': 'lib/image/logo5.jpg', // 👉 add your Angkor Fashion logo here
};

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _navIndex = 1; // Search tab active
  final _searchController = TextEditingController();
  bool _searchActive = false; // whether the search field is shown

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _buyProduct(DipProduct product) {
    Bag.instance.add(
      name: product.name,
      price: product.price,
      imagePath: product.imagePath,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to bag'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openProductDetail(DipProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final isSearching = _searchActive && query.isNotEmpty;

    final results = isSearching
        ? allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList()
        : allProducts;

    // Brands to show: every brand you've configured a picture for in
    // kFeaturedBrandImages always shows up, even before any product uses
    // that brand name — plus any brand that already exists on a real
    // product, falling back to that product's own photo if you haven't
    // set a dedicated logo for it.
    final brands = <String, String>{};
    for (final entry in kFeaturedBrandImages.entries) {
      brands[entry.key] = entry.value;
    }
    for (final p in allProducts) {
      brands.putIfAbsent(p.brand, () => p.imagePath);
    }

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ── TOP BAR ────────────────────────────────────────
              Row(
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _searchActive ? Icons.close_rounded : Icons.search_rounded,
                      color: kTextDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchActive = !_searchActive;
                        if (!_searchActive) _searchController.clear();
                      });
                    },
                  ),
                ],
              ),

              // ── SEARCH FIELD (only when tapped open) ─────────────
              if (_searchActive) ...[
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: kTextDark, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(color: kTextGrey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: kTextGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),

              // ── FEATURED BRANDS (hidden while actively searching) ──
              if (!isSearching) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured brands',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'View more',
                        style: TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 84,
                  child: ScrollConfiguration(
                    behavior: AppScrollBehavior(),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final entry in brands.entries)
                          _BrandItem(name: entry.key, imagePath: entry.value),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // ── TRENDING PRODUCT ───────────────────────────────
                const Text(
                  'Trending product',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 240,
                  child: ScrollConfiguration(
                    behavior: AppScrollBehavior(),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final product in allProducts)
                          _TrendingProductCard(
                            product: product,
                            onTap: () => _openProductDetail(product),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // ── RECOMMENDATION BANNER ─────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    color: kPeach,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "You'll Love These",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: kTextDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Check out your recommendations",
                                    style: TextStyle(fontSize: 12, color: kTextGrey),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kGreen,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      'Explore',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            // Using one of your existing photos for now — to
                            // change it, edit kRecommendBannerImage at the
                            // top of this file, not this line.
                            //
                            // alignment: topCenter crops from the top of the
                            // photo instead of the middle, so it shows the
                            // outfit/face rather than cutting into the legs.
                            child: Image.asset(
                              kRecommendBannerImage,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.face, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ] else ...[
                // ── SEARCH RESULTS ─────────────────────────────────
                Text(
                  'Results (${results.length})',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 14),
                if (results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, color: kTextGrey, size: 40),
                          const SizedBox(height: 10),
                          Text(
                            'No products match "${_searchController.text}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: kTextGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, i) => _SearchProductCard(
                      product: results[i],
                      onTap: () => _openProductDetail(results[i]),
                      onBuy: () => _buyProduct(results[i]),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: Bag.instance,
        builder: (context, _) {
          return AppBottomNav(
            currentIndex: _navIndex,
            bagCount: Bag.instance.itemCount,
            onTap: (i) {
              setState(() => _navIndex = i);
              if (i == 0) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (route) => false,
                );
              } else if (i == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OlderScreen()),
                );
              } else if (i == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
              // i == 1 (Search) — already here, nothing to do.
            },
          );
        },
      ),
    );
  }
}

// ── Brand icon built from a real product photo ─────────────────────────
class _BrandItem extends StatelessWidget {
  final String name;
  final String imagePath;
  const _BrandItem({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: kPeach,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    name.isNotEmpty ? name[0] : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: kTextDark),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: kTextGrey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── Trending product card — heart icon overlay, image, name, price ──────
class _TrendingProductCard extends StatefulWidget {
  final DipProduct product;
  final VoidCallback onTap;
  const _TrendingProductCard({required this.product, required this.onTap});

  @override
  State<_TrendingProductCard> createState() => _TrendingProductCardState();
}

class _TrendingProductCardState extends State<_TrendingProductCard> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        product.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.image, color: kTextGrey)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _isLiked = !_isLiked),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: _isLiked ? Colors.redAccent : kTextGrey,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: kTextDark,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (product.originalPrice != null) ...[
                Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: kTextGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Search-results grid card ────────────────────────────────────────────
class _SearchProductCard extends StatelessWidget {
  final DipProduct product;
  final VoidCallback onTap;
  final VoidCallback onBuy;
  const _SearchProductCard({
    required this.product,
    required this.onTap,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.imagePath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kBg,
                          child: const Icon(Icons.image_not_supported_outlined, color: kTextGrey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              GestureDetector(
                onTap: onBuy,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: kTextDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}