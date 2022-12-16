import 'package:flutter/material.dart';
import 'package:login_page/pages/library_page.dart';
import 'package:login_page/pages/requests_page.dart';
import 'package:login_page/pages/saved_page.dart';
import 'package:login_page/pages/profile_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NewHomePage extends StatefulWidget {
  final String token;
  const NewHomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {

  late final List<Widget> _children;
  late final String _token = widget.token;
  int _selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {

    _children = [
      LibraryPage(token: _token),
       SavedPage(token: _token),
      const RequestsPage(),
      const ProfilePage(),
    ];

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
      appBar: AppBar(
        title: const Text(
          "Libware",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(42, 43, 46, 1),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(42, 43, 46, 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[800]!,
              hoverColor: Colors.grey[600]!,
              gap: 8,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromRGBO(60, 60, 60, 1),
              color: Colors.white,
              activeColor: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.menu_book,
                  text: 'Kitaplık',
                ),
                GButton(
                  icon: Icons.bookmark,
                  text: 'Kaydedilenler',
                ),
                GButton(
                  icon: Icons.check,
                  text: 'Talepler',
                ),
                GButton(
                  icon: Icons.account_box,
                  text: 'Profil',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

