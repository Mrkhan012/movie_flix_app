import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_flix_app/model/movie_model.dart';
import 'package:movie_flix_app/serviecs/api_service.dart';
import 'package:movie_flix_app/widgets/movie_cell.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  List<Results>? _nowPlayingMovies;
  List<Results>? _topRatedMovies;
  List<Results>? _searchResults;
  List<Results>? _originalList;
  int _selectedIndex = 0;

  final MovieService _movieService = MovieService();

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _fetchNowPlayingMovies();
    _fetchTopRatedMovies();
    _searchResults = [];
  }

  Future<void> _fetchNowPlayingMovies() async {
    final nowPlayingMovies = await _movieService.fetchNowPlayingMovies();
    setState(() {
      _nowPlayingMovies = nowPlayingMovies;
      _originalList = _nowPlayingMovies;
    });
  }

  Future<void> _fetchTopRatedMovies() async {
    final topRatedMovies = await _movieService.fetchTopRatedMovies();
    setState(() {
      _topRatedMovies = topRatedMovies;
    });
  }

  // method to filter the movie list based on the search query..
  List<Results> _filterMovieList(List<Results>? movies, String query) {
    if (movies == null) {
      return [];
    }
    return movies
        .where((movie) =>
            movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  void _filterMovies(String query) {
    setState(() {
      _searchResults = (_selectedIndex == 0
              ? _nowPlayingMovies
              : _topRatedMovies)
          ?.where((movie) =>
              movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow.shade700,
        appBar: _buildAppBar(),
        body: _searchResults!.isNotEmpty
            ? _buildMovieList(_searchResults)
            : _buildMovieList(
                _selectedIndex == 0 ? _nowPlayingMovies : _topRatedMovies,
              ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // app bar &  Search bar
  AppBar _buildAppBar() {
    bool showCancelButton = _searchController.text.isNotEmpty;
    return AppBar(
      backgroundColor: Colors.yellow.shade600,
      actions: [
        Expanded(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            border: InputBorder.none,
                          ),
                          onChanged: (query) {
                            _filterMovies(query);
                            setState(() {
                              showCancelButton = true;
                            });
                          },
                        ),
                        if (showCancelButton)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchController.clear();
                                _filterMovies('');
                                showCancelButton = false;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.cancel),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showCancelButton)
          TextButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _filterMovies('');
              });
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.yellow.shade600,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_creation),
          label: "Now Playing",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: "Top Rated",
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          _filterMovies('');
        });
      },
    );
  }

  // movie cell  in ListView.builder
  Widget _buildMovieList(List<Results>? movies) {
    if (movies == null || movies.isEmpty) {
      return const Center(
        child: SpinKitCircle(
          color: Colors.yellow,
          size: 50.0,
        ),
      );
    } else {
      return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          try {
            if (_selectedIndex == 0) {
              await _fetchNowPlayingMovies();
            } else {
              await _fetchTopRatedMovies();
            }
          } catch (e) {
            // Handle errors, e.g., show a snackbar or display an error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error refreshing data: $e'),
              ),
            );
          }
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _buildDismissibleMovieCell(movies[index]);
          },
        ),
      );
    }
  }

  // sweeep to Delete any cell
  Widget _buildDismissibleMovieCell(Results movie) {
    return Dismissible(
      key: Key(movie.id.toString()),
      background: Container(
        color: Colors.red.shade900,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _nowPlayingMovies?.remove(movie);
          _topRatedMovies?.remove(movie);
          _searchResults?.remove(movie);
        });
      },
      child: MovieCell(movie: movie),
    );
  }
}
