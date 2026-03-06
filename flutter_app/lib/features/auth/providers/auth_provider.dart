import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

/// Exposes the current Supabase User (null = unauthenticated)
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
}

/// The raw Supabase auth client
@riverpod
GoTrueClient supabaseAuth(SupabaseAuthRef ref) {
  return Supabase.instance.client.auth;
}
