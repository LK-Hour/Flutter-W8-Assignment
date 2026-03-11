import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryViewModel vm = context.watch<LibraryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildBody(LibraryViewModel vm) {
    // Show loading spinner
    if (vm.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Show error message
    if (vm.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${vm.errorMessage}', textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                vm.fetchSongs();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show list of songs
    return ListView.builder(
      itemCount: vm.songs.length,
      itemBuilder: (context, index) {
        return SongTile(
          song: vm.songs[index],
          isPlaying: vm.isSongPlaying(vm.songs[index]),
          onTap: () {
            vm.start(vm.songs[index]);
          },
        );
      },
    );
  }
}
