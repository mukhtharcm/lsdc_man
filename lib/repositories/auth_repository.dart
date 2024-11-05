import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  final PocketBase _pb;
  static const _authKey = 'pb_auth';

  // Private constructor
  AuthRepository._(this._pb);

  // Factory constructor to initialize with persistent store
  static Future<AuthRepository> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Create AsyncAuthStore with SharedPreferences
    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString(_authKey, data),
      initial: prefs.getString(_authKey),
    );

    // Initialize PocketBase with the async store
    final pb = PocketBase(
      'http://localhost:8090',
      authStore: store,
    );

    return AuthRepository._(pb);
  }

  Future<User> signIn(String email, String password) async {
    final authData = await _pb.collection('users').authWithPassword(
          email,
          password,
        );

    if (authData.record == null) {
      throw Exception('Authentication failed');
    }

    return User.fromRecord(authData.record!);
  }

  Future<User> signUp(String email, String password, String? name) async {
    final body = {
      'email': email,
      'password': password,
      'passwordConfirm': password,
      'name': name,
    };

    final record = await _pb.collection('users').create(body: body);
    return User.fromRecord(record);
  }

  Future<void> signOut() async {
    _pb.authStore.clear();
  }

  bool get isAuthenticated => _pb.authStore.isValid;

  User? get currentUser {
    if (!isAuthenticated || _pb.authStore.model == null) return null;

    final record = RecordModel.fromJson(
      _pb.authStore.model.toJson(),
    );
    return User.fromRecord(record);
  }

  // Listen to auth state changes
  Stream<AuthStoreEvent> get onAuthStateChange => _pb.authStore.onChange;
}
