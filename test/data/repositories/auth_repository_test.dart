import 'package:app4_receitas/data/models/services/auth_service.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './auth_repository_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late MockAuthService mockAuthService;
  late AuthRepository authRepository;

  // Configurando o ambiente de teste antes de TODOS os testes
  setUpAll(() {
    provideDummy<Either<AppError, AuthResponse>>(Right(AuthResponse()));
    provideDummy<Either<AppError, Map<String, dynamic>?>>(
      Right(<String, dynamic>{}),
    );
    provideDummy<Either<AppError, void>>(Right(null));
  });

  // Configura o ambiente de teste antes de cada teste
  setUp(() {
    mockAuthService = MockAuthService();

    // Limpar as DI anteriores
    getIt.reset();

    // Registrar o mock no GetIt
    getIt.registerSingleton<AuthService>(mockAuthService);

    authRepository = AuthRepository();
  });

  // Garantindo que o getIt não mantenha instâncias desnecessárias
  tearDown(() {
    if (getIt.isRegistered<AuthService>()) {
      getIt.unregister<AuthService>();
    }
  });

  group('AuthRepository', () {
    group('currentUser', () {
      test('deve retornar UserProfile quando usuário está logado', () async {
        // Arrange
        final mockUser = User(
          id: 'user-id',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );
        final mockProfile = {'id': 'user-id', 'username': 'testuser'};

        when(mockAuthService.currentUser).thenReturn(mockUser);
        when(
          mockAuthService.fetchUserProfile('user-id'),
        ).thenAnswer((_) async => Right(mockProfile));

        // Act
        final result = await authRepository.currentUser;

        // Assert
        expect(result.isRight, true);
      });

      test('deve retornar erro quando fetchUserProfile falha', () async {
        // Arrange
        final mockUser = User(
          id: 'user-id',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );

        when(mockAuthService.currentUser).thenReturn(mockUser);
        when(
          mockAuthService.fetchUserProfile('user-id'),
        ).thenAnswer((_) async => Left(AppError('Erro ao carregar profile')));

        // Act
        final result = await authRepository.currentUser;

        // Assert
        expect(result.isLeft, true);
        expect(result.left.message, equals('Erro ao carregar profile'));
      });
    });
    group('signInWithPassword', () {
      test('deve retornar UserProfile quando login e bem sucedido', () async {
        // Arrange
        final mockUser = User(
          id: 'user-id',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );
        final mockAuthResponse = AuthResponse(user: mockUser);
        final mockProfile = {'id': 'user-id', 'username': 'testuser'};

        when(
          mockAuthService.signInWithPassword(
            email: 'test@email.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => Right(mockAuthResponse));

        when(
          mockAuthService.fetchUserProfile('user-id'),
        ).thenAnswer((_) async => Right(mockProfile));

        // Act
        final result = await authRepository.signInWithPassword(
          email: 'test@email.com',
          password: 'password123',
        );

        // Assert
        expect(result.isRight, true);
        expect(result.right.username, equals('testuser'));
      });
      test('deve retornar erro quando credenciais sao invalidas', () async {
        // Arrange
        when(
          mockAuthService.signInWithPassword(
            email: 'test@email.com',
            password: 'wrongpassword123',
          ),
        ).thenAnswer(
              (_) async =>
              Left(AppError('Usuario nao cadastrado ou credenciais invalidas')),
        );

        // Act
        final result = await authRepository.signInWithPassword(
          email: 'test@email.com',
          password: 'wrongpassword123',
        );

        // Assert
        expect(result.isLeft, true);
        expect(
          result.left.message,
          equals('Usuario nao cadastrado ou credenciais invalidas'),
        );
      });
      test('deve retornar erro quando email nao foi confirmado', () async {
        // Arrange
        when(
          mockAuthService.signInWithPassword(
            email: 'test@email.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => Left(AppError('E-mail não confirmado')));

        // Act
        final result = await authRepository.signInWithPassword(
          email: 'test@email.com',
          password: 'password123',
        );

        // Assert
        expect(result.isLeft, true);
        expect(result.left.message, equals('E-mail não confirmado'));
      });
      test(
        'deve retornar erro quando UserProfile falha apos login bem sucedido',
            () async {
          // Arrange
          final mockUser = User(
            id: 'user-id',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: DateTime.now().toIso8601String(),
          );
          final mockAuthResponse = AuthResponse(user: mockUser);

          when(
            mockAuthService.signInWithPassword(
              email: 'test@email.com',
              password: 'password123',
            ),
          ).thenAnswer((_) async => Right(mockAuthResponse));

          when(
            mockAuthService.fetchUserProfile('user-id'),
          ).thenAnswer((_) async => Left(AppError('Erro ao carregar profile')));

          // Act
          final result = await authRepository.signInWithPassword(
            email: 'test@email.com',
            password: 'password123',
          );

          // Assert
          expect(result.isLeft, true);
          expect(result.left.message, equals('Erro ao carregar profile'));
          verify(mockAuthService.fetchUserProfile('user-id')).called(1);
        },
      );
      test('deve retornar erro quando ha problema no login', () async {
        // Arrange
        when(
          mockAuthService.signInWithPassword(
            email: 'test@email.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => Left(AppError('Erro ao fazer login')));

        // Act
        final result = await authRepository.signInWithPassword(
          email: 'test@email.com',
          password: 'password123',
        );

        // Assert
        expect(result.isLeft, true);
        expect(result.left.message, equals('Erro ao fazer login'));
      });
    });

    // TODO: signUp e signOut
    group('signUp', () {});
    group('signOut', () {});
  });
}