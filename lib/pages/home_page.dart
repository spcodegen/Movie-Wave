import 'package:flutter/material.dart';
import 'package:moviewave/pages/main_page.dart';
import 'package:moviewave/pages/now_playing_page.dart';
import 'package:moviewave/pages/search_page.dart';
import 'package:moviewave/pages/tv_shows_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _page = [
    const MainPage(),
    const NowPlayingPage(),
    const TvShowsPage(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: "Tv Shows",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
      ),
      body: _page[_selectedIndex],
    );
  }
}
