enum ExplorerGender { male, female }

/// Player explorer used for avatar pick and as the tour-guide character.
class ExplorerAvatar {
  final int id;
  final ExplorerGender gender;
  final String outfitName;
  final String assetPath;

  const ExplorerAvatar({
    required this.id,
    required this.gender,
    required this.outfitName,
    required this.assetPath,
  });

  String get label =>
      '${gender == ExplorerGender.female ? 'Female' : 'Male'} · $outfitName';

  static const choices = [
    ExplorerAvatar(
      id: 0,
      gender: ExplorerGender.male,
      outfitName: 'Field Guide',
      assetPath: 'assets/images/avatars/avatar_1.png',
    ),
    ExplorerAvatar(
      id: 1,
      gender: ExplorerGender.female,
      outfitName: 'Field Guide',
      assetPath: 'assets/images/avatars/avatar_2.png',
    ),
    ExplorerAvatar(
      id: 2,
      gender: ExplorerGender.male,
      outfitName: 'Trail Ranger',
      assetPath: 'assets/images/avatars/avatar_3.png',
    ),
    ExplorerAvatar(
      id: 3,
      gender: ExplorerGender.female,
      outfitName: 'Trail Ranger',
      assetPath: 'assets/images/avatars/avatar_5.png',
    ),
    ExplorerAvatar(
      id: 4,
      gender: ExplorerGender.male,
      outfitName: 'Summit Scout',
      assetPath: 'assets/images/avatars/avatar_4.png',
    ),
    ExplorerAvatar(
      id: 5,
      gender: ExplorerGender.female,
      outfitName: 'Summit Scout',
      assetPath: 'assets/images/avatars/avatar_6.png',
    ),
  ];

  static ExplorerAvatar fromId(int id) {
    if (id >= 0 && id < choices.length) return choices[id];
    return choices.first;
  }
}
