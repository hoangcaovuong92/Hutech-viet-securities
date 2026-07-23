import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSession {
  const AuthSession({required this.email, required this.isAdmin});

  final String email;
  final bool isAdmin;
}

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Không thể đăng nhập vào Firebase.');
    }

    final userDocument = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final isAdmin = userDocument.data()?['role'] == 'admin';
    return AuthSession(email: user.email ?? email, isAdmin: isAdmin);
  }

  Future<void> signOut() => _auth.signOut();

  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-email' => 'Email không đúng định dạng.',
        'invalid-credential' ||
        'user-not-found' ||
        'wrong-password' => 'Email hoặc mật khẩu không chính xác.',
        'user-disabled' => 'Tài khoản đã bị khóa.',
        'too-many-requests' =>
          'Bạn đăng nhập quá nhiều lần. Vui lòng thử lại sau.',
        _ => 'Không thể đăng nhập. Vui lòng thử lại.',
      };
    }
    return 'Không thể kết nối Firebase. Vui lòng thử lại.';
  }
}
