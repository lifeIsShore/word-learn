/// Holds the authenticated user's data in memory.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.subscriptionTier,
    required this.isEmailVerified,
  });

  final String id;
  final String email;
  final String displayName;
  final String subscriptionTier;
  final bool isEmailVerified;

  /// Dev-mode mock user — used when [AppConfig.devModeSkipAuth] is true.
  factory AuthUser.devMock() => const AuthUser(
        id: 'dev-user-001',
        email: 'dev@wordlearn.local',
        displayName: 'Scholar',
        subscriptionTier: 'monthly',
        isEmailVerified: true,
      );

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['display_name'] as String,
        subscriptionTier: json['subscription_tier'] as String,
        isEmailVerified: json['is_email_verified'] as bool,
      );

  AuthUser copyWith({String? displayName, String? subscriptionTier}) =>
      AuthUser(
        id: id,
        email: email,
        displayName: displayName ?? this.displayName,
        subscriptionTier: subscriptionTier ?? this.subscriptionTier,
        isEmailVerified: isEmailVerified,
      );

  @override
  String toString() => 'AuthUser(id: $id, email: $email)';
}
