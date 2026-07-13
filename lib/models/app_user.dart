class AppUser {
  final int id;
  final String username;
  final String displayName;
  final int avatarId;
  final bool avatarChosen;

  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarId,
    this.avatarChosen = false,
  });

  AppUser copyWith({int? avatarId, bool? avatarChosen}) => AppUser(
        id: id,
        username: username,
        displayName: displayName,
        avatarId: avatarId ?? this.avatarId,
        avatarChosen: avatarChosen ?? this.avatarChosen,
      );
}
