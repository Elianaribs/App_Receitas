import 'package:app4_receitas/data/models/services/auth_service.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import '../../di/service_locator.dart';
import '../../utils/app_error.dart';
import '../models/user_profile.dart';

class AuthRepository extends GetxController{
  final _service = getIt<AuthService>();

  //Retorna um UserProfile
  Future<Either<AppError, UserProfile>> get currentUser async {
    final user = _service.currentUser;
    final profile = await _service.fetchUserProfile(user!.id);
    return profile.fold(
          (left) => Left(left),
          (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
    );
  }

  Future<Either<AppError, UserProfile>> signInWithPassword({
    required String email,
    required String password,
}) async {
    final result = await _service.signWithPassword(
        email: email,
        password: password
    );
    return result.fold((left) => Left(left), (right) async {
      final user = right.user!;
      final profileResult = await _service.fetchUserProfile(user.id);
      return profileResult.fold((left) => Left(left),
            (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
      );
    });
 }
}