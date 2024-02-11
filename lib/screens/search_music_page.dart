import 'package:flutter/material.dart';
import 'package:oracomusic/models/search_response.dart';
import 'package:oracomusic/services/song_api.dart';

class SearchMusicPage extends StatefulWidget {
  const SearchMusicPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchMusicPageState createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<SearchMusicPage> {
  late final TextEditingController _searchController = TextEditingController();
  late SearchResponseModel _searchResult = SearchResponseModel(results: []);
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchTextField(),
            const SizedBox(height: 16.0),
            _isSearching ? _buildLoadingIndicator() : _buildSearchResult(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Oraco Music',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  TextField _buildSearchTextField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'Search for artist or song',
        labelStyle: const TextStyle(
          fontSize: 18.0,
          color: Colors.black54,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.black54),
          onPressed: _search,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    if (_searchResult.results.isEmpty) {
      return _buildEmptySearchResult();
    } else {
      return Expanded(
        child: _buildSearchResultList(),
      );
    }
  }

  Widget _buildEmptySearchResult() {
    return const Center(
      child: Text(
        'Search for artist or song',
        style: TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );
  }

  Widget _buildSearchResultList() {
    return ListView.builder(
      itemCount: _searchResult.results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            _searchResult.results[index].trackName,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Text(
            _searchResult.results[index].artistName,
            style: const TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
          leading: const Icon(
            Icons.music_note,
            color: Colors.black54,
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _search() async {
    setState(() {
      _isSearching = true;
    });

    final result = await SongAPI().getSearchMusics(_searchController.text);

    setState(() {
      _searchResult = result;
      _isSearching = false;
    });

    if (_searchResult.results.isEmpty) {
      // Se a lista de resultados estiver vazia, exiba uma mensagem ao usuário
      _showNoResultsDialog();
    }
  }

  void _showNoResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Results", style: TextStyle(color: Colors.black87)),
          content: const Text("No music or artist found", style: TextStyle(color: Colors.black54)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }
}
