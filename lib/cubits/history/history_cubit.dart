import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/models/models.dart';
import 'package:neatflix/utils/utils.dart';

class HistoryCubit extends Cubit<List<Content>> {
  HistoryCubit() : super([]);

  Future<void> fetchHistory() async {
    try {
      final History = await getUserHistory();
      emit(History);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  void removeFromHistory(Content content) {
    final updatedHistory = List<Content>.from(state)..remove(content);
    emit(updatedHistory);
  }
}
