import 'package:flutter/material.dart';
import 'package:moviewave/models/tv_show_model.dart';
import 'package:moviewave/service/tv_shows_service.dart';
import 'package:moviewave/widgets/tv_shows_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TvShow> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  //Fetch Tv Shows
  Future<void> _fetchTvShows() async {
    try {
      List<TvShow> tvShows = await TvShowsService().fetchTVShows();
      print(tvShows.length);
      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (error) {
      print("Error:$error");
      setState(() {
        _error = "Faild to load tv shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tv Shows"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Text(_error),
                )
              : ListView.builder(
                  itemCount: _tvShows.length,
                  itemBuilder: (context, index) {
                    return TvShowsWidget(tvShow: _tvShows[index]);
                  },
                ),
    );
  }
}
