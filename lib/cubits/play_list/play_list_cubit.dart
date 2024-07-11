import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/models/models.dart';
import 'package:neatflix/utils/utils.dart';

class PlayListCubit extends Cubit<List<Content>> {
  PlayListCubit() : super([]);

  Future<void> fetchPlayList() async {
    try {
      final playList = await getUserPlayList();
      emit(playList);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  void addToPlayList(Content content) {
    final updatedList = List<Content>.from(state)..add(content);
    emit(updatedList);
  }

  void removeFromPlayList(Content content) {
    final updatedList = List<Content>.from(state)..remove(content);
    emit(updatedList);
  }
}
