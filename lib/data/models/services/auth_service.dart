import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../di/service_locator.dart';
import '../../../utils/app_error.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  //Retorna o usuário atual
  User? get currentUser => _supabaseClient.auth.currentUser;

//sign in com email e senha
  Future<Either<AppError, AuthResponse>> signWithPassword({
  required String email,
  required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
          email: email,
          password: password
      );
      return Right(response);
    } on AuthException catch (e) {
      switch(e.message) {
        case 'Invalid login credentials':
          return Left(AppError('Usuário não cadastrado ou credenciais inválidas'));
        case 'Email not confirmed':
          return Left(AppError('Email não confirmado'));
        default:
          return Left(AppError('Erro ao fazer login', e));
      }
    }
  }

  //Retorna os valores da tabela profile
  Future<Either<AppError, Map<String, dynamic>?>>fetchUserProfile(String userId) async {
    try {
      final profile = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return Right(profile);
  } catch (e) {
      return Left(AppError ('Erro ao carregar perfil'));
    }
  }
}
