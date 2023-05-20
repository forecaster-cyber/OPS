import 'main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AuthManager {
  
  

  Future<void> signIn(String email, String password) async {
    final AuthResponse response =
                              await supabase.auth.signInWithPassword(
                            email: email,
                            password: password,
                          );
    
  }

  Future<void> signUp(String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(
                            email: email,
                            password: password,
                          );
  }

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}
