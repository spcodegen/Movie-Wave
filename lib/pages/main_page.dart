import 'package:flutter/material.dart';
import 'package:moviewave/models/movies_model.dart';
import 'package:moviewave/pages/single_move_details_page.dart';
import 'package:moviewave/service/movies_service.dart';
import 'package:moviewave/widgets/movie_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  //This method fetches the upcoming movies from the API and this method is called in the initState method

  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    try {
      final newMovies =
          await MoviesService().fetchUpcommingMovies(page: _currentPage);
      print(newMovies.length);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (error) {
      print("Error:$error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovieWave',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            _fetchMovies();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _movies.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movies.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final Movie movie = _movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleMoveDetailsPage(movie: movie),
                  ),
                );
              },
              child: MovieDetailsWidget(
                movie: movie,
              ),
            );
          },
        ),
      ),
    );
  }
}
