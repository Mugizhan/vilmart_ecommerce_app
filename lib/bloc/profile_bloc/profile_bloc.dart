import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/profile_model/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadUserProfileAndShops>(_onLoadUserProfileAndShops);
  }

  Future<void> _onLoadUserProfileAndShops(
      LoadUserProfileAndShops event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profileData = await repository.fetchUserProfileAndShops();
      emit(ProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
