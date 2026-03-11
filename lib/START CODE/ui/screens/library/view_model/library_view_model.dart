import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Song> songs = [];

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);
    fetchSongs();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void fetchSongs() async {
    // 1 - Set loading to true
    isLoading = true;
    hasError = false;
    errorMessage = '';
    songs = [];
    notifyListeners();

    // 2 - Try to fetch songs from the repository
    try {
      List<Song> result = await songRepository.fetchSongs();
      songs = result;
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
    }

    // 3 - Notify the UI
    notifyListeners();
  }

  bool isSongPlaying(Song song) {
    return playerState.currentSong == song;
  }

  void start(Song song) {
    playerState.start(song);
  }

  void stop(Song song) {
    playerState.stop();
  }
}
