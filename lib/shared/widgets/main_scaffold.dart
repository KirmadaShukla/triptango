import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // For BackdropFilter

class MainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  const MainScaffold({Key? key, required this.child, required this.currentIndex})
      : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool _isProfileTapped = false;

  void _onProfileTap() {
    setState(() => _isProfileTapped = true);
    GoRouter.of(context).go('/profile');
    Future.delayed(const Duration(milliseconds: 200),
        () => setState(() => _isProfileTapped = false));
  }

  void _onItemTapped(int index) {
    final routes = ['/home', '/explore', '/create', '/matches', '/wishlist'];
    if (index != widget.currentIndex) {
      GoRouter.of(context).go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28.0, sigmaY: 28.0), // Even more blur
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA).withOpacity(0.18), // Very light blue, very transparent
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.12), // Even softer border
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.03), // Very subtle shadow
                    blurRadius: 20.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF2193b0), // blue
                Color(0xFF6dd5ed), // light blue
                Color(0xFFf7971e), // orange
                Color(0xFFFF5858), // red
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'TripTango',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white, // This will be masked by the gradient
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.black38,
                  offset: Offset(1.5, 1.5),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AnimatedScale(
              scale: _isProfileTapped ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_circle,
                  size: 28,
                  color: Color(0xFF2A9D8F), // Tropical green
                ),
              ),
            ),
            onPressed: _onProfileTap,
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28.0, sigmaY: 28.0), // Match AppBar/BottomNav blur
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA).withOpacity(0.18), // Match AppBar/BottomNav color
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12), // Subtle border
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.03), // Very subtle shadow
                        blurRadius: 20.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28.0, sigmaY: 28.0), // Match AppBar blur
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA).withOpacity(0.18), // Match AppBar color
              border: const Border(
                top: BorderSide(
                  color: Color(0x1FFFFFFF), // Subtle white border
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.03), // Very subtle shadow
                  blurRadius: 20.0,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  activeIcon: Icon(Icons.home_filled),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.compass_calibration),
                  label: 'Explore',
                  activeIcon: Icon(Icons.explore),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.luggage),
                  label: 'Create',
                  activeIcon: Icon(Icons.luggage),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Matches',
                  activeIcon: Icon(Icons.group_add),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: 'Wishlist',
                  activeIcon: Icon(Icons.favorite),
                ),
              ],
              currentIndex: widget.currentIndex,
              onTap: _onItemTapped,
              selectedItemColor: const Color(0xFF2A9D8F), // Tropical green
              unselectedItemColor: const Color(0xFF90A4AE), // Blue-grey for better readability
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent, // Now handled by parent container
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}