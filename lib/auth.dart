import 'main.dart';

class AuthManager {
  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}
