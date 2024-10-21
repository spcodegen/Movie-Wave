import 'package:flutter/material.dart';
import 'package:moviewave/models/movies_model.dart';
import 'package:moviewave/service/movies_service.dart';
import 'package:moviewave/widgets/search_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchresults = [];
  bool _isLoading = false;
  String _error = "";

  //Method to search for movies
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      print(_searchController.text);
      List<Movie> movies =
          await MoviesService().searchMovies(_searchController.text);

      setState(() {
        _searchresults = movies;
      });
    } catch (error) {
      print("Error:$error");
      setState(() {
        _error = "Faild to search that movie";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Movies"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search for a movie",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _searchMovies(),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _searchMovies,
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                        weight: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_searchresults.isEmpty)
              const Center(
                child: Text("No movies found.please Search..."),
              )
            else
              Expanded(
                  child: ListView.builder(
                itemCount: _searchresults.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SearchWidget(
                        movie: _searchresults[index],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ))
          ],
        ),
      ),
    );
  }
}
