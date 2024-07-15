import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/utils/utils.dart';

class AvatarCubit extends Cubit<String> {
  AvatarCubit() : super('');

  Future<void> fetchAvatar() async {
    try {
      final avatar = await getRandomAvatar();
      emit(avatar);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
