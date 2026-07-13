import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import 'game_image.dart';

/// The player's chosen tour-guide explorer with a speech bubble.
class AvatarSpeechBubble extends StatelessWidget {
  final String text;
  final double avatarSize;
  final double fontSize;
  final bool showAvatar;
  /// Scales the explorer art up inside its slot (PNG assets have extra padding).
  final double avatarScale;
  /// When true, speech sits at the top while the avatar stays anchored at the bottom.
  final bool alignSpeechTop;
  /// Caps speech-bubble width; when null the bubble uses remaining row width.
  final double? speechMaxWidth;
  final Color? speechBackground;
  final Color? speechBorderColor;
  final double speechBorderWidth;
  final List<BoxShadow>? speechShadow;

  /// When true, the avatar and speech bubble stay grouped and centered in the
  /// parent instead of stretching across the full width.
  final bool centerContent;

  /// Nudges the avatar downward when [centerContent] is true.
  final double avatarOffsetY;

  /// Optional override when previewing before login (e.g. avatar select).
  final int? avatarId;

  const AvatarSpeechBubble({
    super.key,
    required this.text,
    this.avatarSize = 200,
    this.fontSize = 22,
    this.showAvatar = true,
    this.avatarScale = 1.35,
    this.alignSpeechTop = false,
    this.speechMaxWidth,
    this.speechBackground,
    this.speechBorderColor,
    this.speechBorderWidth = 3,
    this.speechShadow,
    this.centerContent = false,
    this.avatarOffsetY = 2,
    this.avatarId,
  });

  @override
  Widget build(BuildContext context) {
    final id = avatarId ?? context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);

    final speech = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: speechMaxWidth ?? double.infinity,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: speechBackground ?? Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: speechBorderColor ?? BioColors.forest,
            width: speechBorderWidth,
          ),
          boxShadow: speechShadow,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            height: 1.3,
            color: BioColors.ink,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    if (alignSpeechTop) {
      return Row(
        mainAxisSize: centerContent ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment:
            centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
        children: [
          if (showAvatar) ...[
            Transform.translate(
              offset: Offset(0, centerContent ? avatarOffsetY : 0),
              child: SizedBox(
                width: avatarSize,
                child: Align(
                  alignment: centerContent
                      ? Alignment.center
                      : Alignment.bottomCenter,
                  child: SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: OverflowBox(
                      alignment: Alignment.bottomCenter,
                      maxHeight: avatarSize * avatarScale,
                      minHeight: avatarSize * avatarScale,
                      maxWidth: avatarSize * avatarScale,
                      child: SizedBox(
                        height: avatarSize * avatarScale,
                        child: GameImage(
                          asset: explorer.assetPath,
                          label: explorer.label,
                          color: BioColors.moss,
                          fit: BoxFit.fitHeight,
                          icon: Icons.emoji_people,
                          cacheWidth: (avatarSize * avatarScale * 2).round(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (centerContent)
            speech
          else
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: speech,
              ),
            ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showAvatar) ...[
          SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              maxHeight: avatarSize * avatarScale,
              minHeight: avatarSize * avatarScale,
              maxWidth: avatarSize * avatarScale,
              child: SizedBox(
                height: avatarSize * avatarScale,
                child: GameImage(
                  asset: explorer.assetPath,
                  label: explorer.label,
                  color: BioColors.moss,
                  fit: BoxFit.fitHeight,
                  icon: Icons.emoji_people,
                  cacheWidth: (avatarSize * avatarScale * 2).round(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: speech),
      ],
    );
  }
}
