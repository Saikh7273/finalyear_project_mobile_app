import 'dart:async';
import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/menu/bottom_nav.dart';
import 'package:present_group2/menu/older_sceen.dart';
import 'package:present_group2/menu/profile_screen.dart';
import 'package:present_group2/screen/product_detail_screen.dart';
import 'package:present_group2/menu/research_screen.dart';

// ── Model ─────────────────────────────────────────────────────────────
class DipProduct {
  final String name;
  final String imagePath;
  final double price;
  final double? originalPrice;
  final String description;
  final String brand;
  final List<String> sizes;
  const DipProduct({
    required this.name,
    required this.imagePath,
    required this.price,
    this.originalPrice,
    this.description = 'No description available for this product yet.',
    this.brand = 'Angkor Fashion',
    this.sizes = const ['S', 'M', 'L', 'XL'],
  });
}

// ── Sample data ──────────────────────────────────────────────────────
// 👉 ADD YOUR IMAGES: put files in lib/image/ and update these paths.
final List<DipProduct> _sellingFast = [
  const DipProduct(
    name: 'Basic High Split',
    imagePath: 'lib/image/clothes.jpg', // 👉 add image here
    price: 25.00,
    originalPrice: 45.00,
    description:
        'Made with wool blend fabric. Lapel collar and long sleeve. '
        'Front flap pockets and welt pocket at chest. Interior lining.',
    brand: 'Zara',
  ),
  const DipProduct(
    name: 'Long Faux Shearling',
    imagePath: 'lib/image/clothes1.jpg', // 👉 add image here
    price: 60.00,
    originalPrice: 89.00,
    description:
        'Cozy faux shearling coat with a relaxed silhouette. '
        'Front button closure and side pockets.',
    brand: 'Zara',
  ),
];

final List<DipProduct> _popular = [
  const DipProduct(
    name: 'Knit Sweater',
    imagePath: 'lib/image/clothes5.jpg', // 👉 add image here
    price: 38.00,
    description:
        'Soft knit sweater with ribbed cuffs and hem. Relaxed, everyday fit.',
    brand: 'Angkor Fashion',
  ),
  const DipProduct(
    name: 'Denim Jacket',
    imagePath: 'lib/image/clothes6.jpg', // 👉 add image here
    price: 52.00,
    description:
        'Classic denim jacket with button front and chest pockets.',
    brand: 'Angkor Fashion',
  ),
    const DipProduct(
    name: 'Tailored Blazer & Wide-Leg Trousers Set',
    imagePath: 'lib/image/girlpic1.jpg', // 👉 add image here
    price: 89.00,
    description:
        'A chic, minimalist business-casual look featuring high-waisted beige slacks and a matching relaxed-fit blazer.',
    brand: 'Angkor Fashion',
  ),
    const DipProduct(
    name: 'Classic Trench Coat & High-Waist Trouser Ensemble',
    imagePath: 'lib/image/girlpic2.jpg', // 👉 add image here
    price: 120.00,
    description:
        'Elegant outerwear style featuring a long taupe trench coat paired with structured black trousers and a matching handbag.',
    brand: 'Angkor Fashion',
  ),
    const DipProduct(
    name: 'Satin Camisole & Flare Dress Pants',
    imagePath: 'lib/image/girlpic5.jpg', // 👉 add image here
    price: 65.00,
    description:
        'A sophisticated evening or lounge look combining a glossy champagne satin top with deep espresso brown flared trousers.',
    brand: 'Angkor Fashion',
  ),
      const DipProduct(
    name: 'Denimalist Silk Blouse & Pleated Midi Skirt',
    imagePath: 'lib/image/girlpic6.jpg', // 👉 add image here
    price: 52.00,
    description:
        'Classic denim jacket with button front and chest pockets.',
    brand: 'Angkor Fashion',
  ),
];

/// All products across every section on Home, in one place. The search
/// screen imports this instead of keeping its own separate product data,
/// so search results always match what's actually shown on Home.
final List<DipProduct> allProducts = [..._sellingFast, ..._popular];

// ── MAIN SCREEN ──────────────────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0;

  // ── Banner slider ─────────────────────────────────────────────────
  // 👉 ADD MORE BANNER IMAGES: just add more paths to this list — the
  // slider and dot indicators size themselves automatically.
  final List<String> _bannerImages = [
    'lib/image/banner1.png',
    'lib/image/bannerpic.jpg',
    'lib/image/bannerpic2.jpg',
  ];
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  Timer? _bannerTimer;
  // Only true while a mouse is actually hovering the banner (web/desktop).
  // Touch devices have no "hover", so on a real phone the text/button
  // below would never show — worth knowing if you ship this to mobile.
  bool _bannerHovered = false;

  @override
  void initState() {
    super.initState();
    // Auto-slide, same pattern as OnboardingScreen.
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_bannerController.hasClients) return;
      _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        _bannerIndex,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),

              // ── Top bar — gradient logo badge + wordmark instead of
              // bare text, shadowed round icon buttons on the right,
              // matching the login/register brand mark ─────────────
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kGreen, kGreenDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: kGreen.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Angkor Fashion',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: kTextDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  _RoundIconButton(
                    icon: Icons.mail_outline_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _RoundIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Banner — sliding carousel, same auto-advance +
              // dot-indicator pattern as OnboardingScreen ───────────
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: kShadow,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                // MouseRegion only fires on web/desktop with an actual
                // mouse pointer — that's what drives the hover reveal.
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _bannerHovered = true),
                  onExit: (_) => setState(() => _bannerHovered = false),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _bannerController,
                        itemCount: _bannerImages.length,
                        onPageChanged: (i) => setState(() => _bannerIndex = i),
                        itemBuilder: (context, i) {
                          return Image.asset(
                            _bannerImages[i],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: kTextDark),
                          );
                        },
                      ),

                      // Dark overlay — only fades in on hover, so the
                      // photo stays bright and undarkened by default.
                      IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _bannerHovered ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                        ),
                      ),

                      // Text + button — hidden until hovered. IgnorePointer
                      // while hidden so the invisible "Shop Now" button
                      // can't be tapped/clicked.
                      IgnorePointer(
                        ignoring: !_bannerHovered,
                        child: AnimatedOpacity(
                          opacity: _bannerHovered ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'New Winter 2026\ncollections',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: kTextDark,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 26,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    'Shop Now',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Dot indicators, bottom-center — always visible.
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_bannerImages.length, (i) {
                            final active = i == _bannerIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: active ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Selling fast ───────────────────────────────────
              const Text(
                'Selling fast 🔥',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 260,
                child: Row(
                  children: [
                    Expanded(child: _SaleProductCard(product: _sellingFast[0])),
                    const SizedBox(width: 14),
                    Expanded(child: _SaleProductCard(product: _sellingFast[1])),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Popular products ─────────────────────────────────
              const Text(
                'Popular products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),
              // Same card height (260) as the "Selling fast" row above.
              // childAspectRatio alone can't guarantee an exact pixel
              // height — it only fixes width:height *ratio* — so we
              // measure the actual available width here and derive the
              // ratio that produces a 260-tall card at that width.
              LayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisSpacing = 14.0;
                  const cardHeight = 260.0; // match Selling fast card height
                  final itemWidth =
                      (constraints.maxWidth - crossAxisSpacing) / 2;
                  final aspectRatio = itemWidth / cardHeight;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _popular.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: 14,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, i) =>
                        _PopularProductCard(product: _popular[i]),
                  );
                },
              ),
              const SizedBox(height: 24),
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
              if (i == 1) {
                // Search tab index
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              } else if (i == 2) {
                // Bag tab index
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OlderScreen()),
                );
              } else if (i == 3) {
                // Profile tab index
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// Opens the product detail screen.
void _openProductDetail(BuildContext context, DipProduct product) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
  );
}

// Adds a product to the shared bag. Doesn't navigate — only the Bag
// tab in the bottom nav opens the bag screen.
void _buyProduct(BuildContext context, DipProduct product) {
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

// ── Small round icon button (mail / notifications) ─────────────────────
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 19, color: kTextDark),
      ),
    );
  }
}

// ── Sale product card (discount badge + strike-through price) ────────────
class _SaleProductCard extends StatelessWidget {
  final DipProduct product;
  const _SaleProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final discountPct = product.originalPrice != null
        ? (((product.originalPrice! - product.price) /
                      product.originalPrice!) *
                  100)
              .round()
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tapping the image or name opens the product detail screen.
          // The buy button below is a separate tap target so it can
          // still add straight to the bag without navigating away.
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () => _openProductDetail(context, product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                product.imagePath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if (discountPct != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: kBadgePink,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBadgePink.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '-$discountPct%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
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
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kGreenDark,
                        ),
                      ),
                    ),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '\$${product.originalPrice!.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: kTextGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _BuyButton(onTap: () => _buyProduct(context, product)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Popular product card (simple, no discount) ───────────────────────────
class _PopularProductCard extends StatelessWidget {
  final DipProduct product;
  const _PopularProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openProductDetail(context, product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                product.imagePath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: kGreenDark,
                ),
              ),
              _BuyButton(onTap: () => _buyProduct(context, product)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Small "buy" button used on both card types ────────────────────────
class _BuyButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BuyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kGreen, kGreenDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: kGreen.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.shopping_bag_rounded,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}