import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/circle_image_button.dart';
import '../../core/widgets/forest_image_button.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/guide_hint.dart';
import '../../core/widgets/station_progress_bar.dart';
import '../../core/widgets/references_panel.dart';
import '../../data/stations.dart';
import '../../models/station_info.dart';
import '../../models/station_progress.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import 'badge_wardrobe_overlay.dart';

class ExpeditionMapScreen extends StatefulWidget {
  const ExpeditionMapScreen({super.key});

  @override
  State<ExpeditionMapScreen> createState() => _ExpeditionMapScreenState();
}

class _ExpeditionMapScreenState extends State<ExpeditionMapScreen> {
  // Basecamp sits at the trail head; stations follow, then the summit. The
  // points wind up-slope (lower-left to upper-right) so the path reads like a
  // mountain ascent.
  static const Offset _basecampSpot = Offset(0.07, 0.82);
  static const List<Offset> _spots = [
    Offset(0.21, 0.62),
    Offset(0.35, 0.42),
    Offset(0.50, 0.60),
    Offset(0.66, 0.34),
    Offset(0.80, 0.56),
  ];
  static const Offset _summitSpot = Offset(0.93, 0.20);

  final TransformationController _tc = TransformationController();
  bool _legendOpen = false;
  bool _badgesOpen = false;
  bool _referencesOpen = false;
  bool _aiDeclarationOpen = false;
  bool _defaultViewApplied = false;
  Size? _viewportSize;

  /// Default camera: slightly zoomed in, centered on Station 1.
  static const double _defaultScale = 1.38;

  List<Offset> get _trail => [_basecampSpot, ..._spots, _summitSpot];

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  void _applyDefaultView(Size viewportSize) {
    final focus = _spots.first;
    final target = Offset(
      focus.dx * viewportSize.width,
      focus.dy * viewportSize.height,
    );
    final cx = viewportSize.width / 2;
    final cy = viewportSize.height / 2;
    _tc.value = Matrix4.identity()
      ..translateByDouble(
        cx - target.dx * _defaultScale,
        cy - target.dy * _defaultScale,
        0,
        1,
      )
      ..scaleByDouble(_defaultScale, _defaultScale, _defaultScale, 1.0);
  }

  void _ensureDefaultView(Size viewportSize) {
    _viewportSize = viewportSize;
    if (_defaultViewApplied) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _defaultViewApplied) return;
      _applyDefaultView(viewportSize);
      _defaultViewApplied = true;
    });
  }

  void _zoomBy(double factor) {
    final next = (_tc.value.getMaxScaleOnAxis() * factor).clamp(1.0, 3.5);
    // Re-anchor around the centre of the current view.
    _tc.value = Matrix4.identity()..scaleByDouble(next, next, next, 1.0);
  }

  void _resetView() {
    if (_viewportSize != null) {
      _applyDefaultView(_viewportSize!);
    } else {
      _tc.value = Matrix4.identity();
    }
  }

  /// Index of the furthest node on the trail the explorer has reached.
  /// 0 = basecamp, 1..5 = stations, 6 = summit.
  int _reachedIndex(ProgressService progress) {
    if (progress.isCompleted('summit')) return 6;
    return progress.completedCount.clamp(0, 5);
  }

  /// Key of the station the explorer should tackle next (for the "You are
  /// here" pin). Falls back to basecamp / summit at the extremes.
  String _activeKey(ProgressService progress) {
    for (final s in kStations) {
      if (progress.progressOf(s.key).status == StationStatus.unlocked) {
        return s.key;
      }
    }
    if (progress.isUnlocked('summit') && !progress.isCompleted('summit')) {
      return 'summit';
    }
    return progress.completedCount == 0 ? 'basecamp' : 'summit';
  }

  bool _showPretestGuide(ProgressService progress) => !progress.hasTakenPretest;

  bool _showStation1Guide(ProgressService progress) =>
      progress.hasTakenPretest && !progress.isCompleted('station1');

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();
    final reached = _reachedIndex(progress);
    final activeKey = _activeKey(progress);
    return BioScaffold(
      title: 'Expedition Map',
      backgroundAsset: 'assets/images/backgrounds/map.jpg',
      backgroundLabel: 'Expedition map',
      fullBleedBackground: true,
      scrimOpacity: 0.48,
      onBack: () => context.go('/basecamp?fromMap=1'),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(14),
          ),
          child: StationProgressBar(progress: progress),
        ),
        const SizedBox(width: 8),
        _logoutButton(context),
      ],
      padding: EdgeInsets.zero,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: LayoutBuilder(
          builder: (context, c) {
            final size = Size(c.maxWidth, c.maxHeight);
            _ensureDefaultView(size);
            return Stack(
              children: [
                // The interactive map fills the whole frame. ClipRect
                // guarantees the zoomed/panned content can never overflow.
                Positioned.fill(
                  child: ClipRect(
                    child: InteractiveViewer(
                      transformationController: _tc,
                      minScale: 1.0,
                      maxScale: 3.5,
                      boundaryMargin: EdgeInsets.zero,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: _mapContent(
                          context,
                          size,
                          progress,
                          reached,
                          activeKey,
                        ),
                      ),
                    ),
                  ),
                ),
                // Fixed overlays (do not zoom/pan with the map).
                Positioned(left: 14, top: 12, child: _hintChip()),
                Positioned(left: 14, top: 52, child: _legendButton()),
                Positioned(
                  left: 14,
                  top: 92,
                  child: _badgesButton(progress.earnedBadges.length),
                ),
                if (_legendOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() => _legendOpen = false),
                    ),
                  ),
                  Center(child: _legendOverlay()),
                ],
                if (_badgesOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() => _badgesOpen = false),
                    ),
                  ),
                  Center(
                    child: BadgeWardrobeOverlay(
                      progress: progress,
                      onClose: () => setState(() => _badgesOpen = false),
                    ),
                  ),
                ],
                if (_referencesOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() => _referencesOpen = false),
                    ),
                  ),
                  Center(
                    child: ReferencesPanel(
                      onClose: () => setState(() => _referencesOpen = false),
                    ),
                  ),
                ],
                if (_aiDeclarationOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() => _aiDeclarationOpen = false),
                    ),
                  ),
                  Center(
                    child: _infoOverlay(
                      title: 'AI Use Declaration',
                      icon: Icons.memory_rounded,
                      onClose: () => setState(() => _aiDeclarationOpen = false),
                      body:
                          'Artificial Intelligence (AI) tools were utilized in '
                          'the development of this instructional material to '
                          'assist in content drafting, language enhancement, '
                          'instructional design, and the enhancement of images '
                          'from sketches into educational visuals. All '
                          'AI-assisted outputs were critically reviewed, '
                          'verified, and refined by the author to ensure '
                          'accuracy, curriculum alignment, and appropriateness '
                          'for educational use. The author retains full '
                          'responsibility for the final content and design of '
                          'this material.',
                    ),
                  ),
                ],
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _mapInfoButtons(),
                      const SizedBox(width: 16),
                      _zoomControls(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _mapContent(
    BuildContext context,
    Size size,
    ProgressService progress,
    int reached,
    String activeKey,
  ) {
    final showStationGuide = _showStation1Guide(progress);
    final basecampPos = _at(_basecampSpot, size);
    final station1Pos = _at(_spots.first, size);

    return Stack(
      children: [
        // The winding ascent trail with the completed portion highlighted.
        Positioned.fill(
          child: CustomPaint(painter: _TrailPainter(_trail, reached)),
        ),
        if (showStationGuide)
          Positioned.fill(
            child: _TrailGuideOverlay(from: basecampPos, to: station1Pos),
          ),
        // Compass rose baked into the map.
        Positioned(top: 14, right: 16, child: _compass()),
        // Markers.
        _basecampPanel(context, basecampPos, activeKey == 'basecamp', progress),
        for (var i = 0; i < kStations.length; i++)
          _marker(
            context,
            kStations[i],
            _at(_spots[i], size),
            progress,
            activeKey == kStations[i].key,
            showGuide: showStationGuide && kStations[i].key == 'station1',
          ),
        _summitMarker(
          context,
          _at(_summitSpot, size),
          progress,
          activeKey == 'summit',
        ),
      ],
    );
  }

  Offset _at(Offset frac, Size size) =>
      Offset(frac.dx * size.width, frac.dy * size.height);

  Widget _hintChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pinch, size: 16, color: BioColors.forest),
          SizedBox(width: 6),
          Text(
            'Pinch to zoom  ·  Drag to explore',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BioColors.forest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _roundBtn(Icons.add, 'Zoom in', () => _zoomBy(1.4)),
        const SizedBox(height: 8),
        _roundBtn(Icons.remove, 'Zoom out', () => _zoomBy(1 / 1.4)),
        const SizedBox(height: 8),
        _roundBtn(Icons.center_focus_strong, 'Reset view', _resetView),
      ],
    );
  }

  Widget _mapInfoButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleImageButton(
          asset: 'assets/images/ui/btn_references_circle.png',
          label: 'References',
          size: 72,
          borderColor: BioColors.sun,
          onTap: () => setState(() {
            _referencesOpen = true;
            _aiDeclarationOpen = false;
            _legendOpen = false;
            _badgesOpen = false;
          }),
        ),
        const SizedBox(width: 14),
        CircleImageButton(
          asset: 'assets/images/ui/btn_ai_declaration_circle.png',
          label: 'AI Use Declaration',
          size: 72,
          borderColor: BioColors.sun,
          onTap: () => setState(() {
            _aiDeclarationOpen = true;
            _referencesOpen = false;
            _legendOpen = false;
            _badgesOpen = false;
          }),
        ),
      ],
    );
  }

  Widget _infoOverlay({
    required String title,
    required IconData icon,
    required VoidCallback onClose,
    required String body,
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 640,
        constraints: const BoxConstraints(maxHeight: 420),
        padding: const EdgeInsets.fromLTRB(28, 24, 16, 28),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: BioColors.forest, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    color: BioColors.forest,
                    size: 30,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  body,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: BioColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn(IconData icon, String tip, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: Tooltip(
        message: tip,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: BioColors.forest, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _compass() {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.85),
        border: Border.all(color: BioColors.bark, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: CustomPaint(size: const Size(48, 48), painter: _CompassPainter()),
    );
  }

  Widget _legendButton() {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => setState(() {
          _legendOpen = true;
          _badgesOpen = false;
          _referencesOpen = false;
          _aiDeclarationOpen = false;
        }),
        borderRadius: BorderRadius.circular(20),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.legend_toggle, size: 18, color: BioColors.forest),
              SizedBox(width: 6),
              Text(
                'Legend',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badgesButton(int earnedCount) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => setState(() {
          _badgesOpen = true;
          _legendOpen = false;
          _referencesOpen = false;
          _aiDeclarationOpen = false;
        }),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.military_tech,
                size: 18,
                color: BioColors.forest,
              ),
              const SizedBox(width: 6),
              const Text(
                'Badges',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BioColors.forest,
                ),
              ),
              if (earnedCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: BioColors.sun,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$earnedCount',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendOverlay() {
    Widget row(Color color, String label) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: BioColors.ink,
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 520,
        padding: const EdgeInsets.fromLTRB(28, 24, 16, 28),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.legend_toggle,
                  color: BioColors.forest,
                  size: 34,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Map Legend',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _legendOpen = false),
                  icon: const Icon(
                    Icons.close,
                    color: BioColors.forest,
                    size: 30,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 12),
            row(BioColors.sun, 'Trail conquered'),
            row(BioColors.bark.withValues(alpha: 0.55), 'Trail ahead'),
            row(BioColors.correct, 'Completed station'),
            row(Colors.grey.shade500, 'Locked station'),
          ],
        ),
      ),
    );
  }

  Widget _basecampPanel(
    BuildContext context,
    Offset pos,
    bool active,
    ProgressService progress,
  ) {
    final showPretestGuide = _showPretestGuide(progress);
    return Positioned(
      left: pos.dx - 84,
      top: pos.dy - 340,
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active)
            const Align(
              alignment: Alignment.centerLeft,
              child: _YouAreHerePin(),
            )
          else
            const SizedBox(height: 22),
          ForestImageButton(
            asset: 'assets/images/ui/btn_basecamp.png',
            label: 'Base Camp',
            height: 108,
            onTap: () => context.go('/basecamp?fromMap=1'),
          ),
          const SizedBox(height: 12),
          const ForestImageDisplay(
            asset: 'assets/images/ui/btn_start_exploration.png',
            label: 'Start Exploration',
            height: 92,
          ),
          const SizedBox(height: 12),
          GuideHint(
            enabled: showPretestGuide,
            label: 'Start here',
            arrowAbove: false,
            child: ForestImageButton(
              asset: 'assets/images/ui/btn_pretest.png',
              label: 'Pretest',
              height: 92,
              onTap: () => context.go('/pretest'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marker(
    BuildContext context,
    StationInfo s,
    Offset pos,
    ProgressService progress,
    bool active, {
    bool showGuide = false,
  }) {
    final status = progress.progressOf(s.key).status;
    final locked = status == StationStatus.locked;
    final completed = status == StationStatus.completed;
    return _markerShell(
      pos: pos,
      active: active,
      showGuide: showGuide && !locked && !completed,
      onTap: locked ? null : () => _openStation(context, s),
      circle: _Pulse(
        enabled: !locked && !completed,
        child: _stationLogoBadge(
          asset: s.logoAsset,
          label: s.title,
          borderColor: completed ? BioColors.correct : Colors.white,
          locked: locked,
          completed: completed,
        ),
      ),
      label: 'Station ${s.order}',
      sublabel: completed
          ? 'Cleared'
          : locked
          ? 'Locked'
          : 'Ready',
    );
  }

  Widget _summitMarker(
    BuildContext context,
    Offset pos,
    ProgressService progress,
    bool active,
  ) {
    final unlocked = progress.isUnlocked('summit');
    return _markerShell(
      pos: pos,
      active: active,
      onTap: unlocked ? () => context.go('/summit') : null,
      circle: _stationLogoBadge(
        asset: 'assets/images/stations/logo_summit.png',
        label: 'Summit',
        borderColor: Colors.white,
        locked: !unlocked,
        completed: progress.isCompleted('summit'),
      ),
      label: 'Summit',
      sublabel: '2,400 m',
    );
  }

  /// Shared marker layout: circular badge + name chip + optional elevation /
  /// status sub-label, with a "You are here" pin when [active].
  Widget _markerShell({
    required Offset pos,
    required bool active,
    required VoidCallback? onTap,
    required Widget circle,
    required String label,
    required String sublabel,
    bool showGuide = false,
  }) {
    return Positioned(
      left: pos.dx - 64,
      top: pos.dy - (showGuide ? 118 : 78),
      width: 128,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showGuide)
              const MapGuidePin(label: 'Start Station 1')
            else if (active)
              const _YouAreHerePin()
            else
              const SizedBox(height: 22),
            if (showGuide) _GuideRing(child: circle) else circle,
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(9),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: BioColors.bark.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stationLogoBadge({
    required String asset,
    required String label,
    required Color borderColor,
    required bool locked,
    required bool completed,
  }) {
    const size = 92.0;
    Widget logo = ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: GameImage(
          asset: asset,
          label: label,
          fit: BoxFit.cover,
          cacheWidth: 256,
        ),
      ),
    );

    if (locked) {
      logo = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.35,
          0.35,
          0.35,
          0,
          0,
          0.35,
          0.35,
          0.35,
          0,
          0,
          0.35,
          0.35,
          0.35,
          0,
          0,
          0,
          0,
          0,
          0.75,
          0,
        ]),
        child: logo,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 4),
            ),
            child: logo,
          ),
          if (locked)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.28),
              ),
              child: const Icon(Icons.lock, color: Colors.white, size: 34),
            ),
          if (completed)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: BioColors.correct,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  void _openStation(BuildContext context, StationInfo s) {
    if (s.implemented) {
      final route = s.splashAsset != null
          ? '/station/${s.key}/splash'
          : '/station/${s.key}/intro';
      context.go(route);
    } else {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(s.title),
          content: const Text(
            'This station is on the way! It will be added soon. '
            'For now, keep exploring the stations that are ready.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _logoutButton(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: Tooltip(
        message: 'Log out',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            final auth = context.read<AuthService>();
            final progress = context.read<ProgressService>();
            await auth.logout();
            progress.clear();
            if (!context.mounted) return;
            context.go('/');
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.logout, color: BioColors.forest, size: 26),
          ),
        ),
      ),
    );
  }
}

/// Small bouncing "You are here" pin shown above the active marker.
class _YouAreHerePin extends StatelessWidget {
  const _YouAreHerePin();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: BioColors.sun,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: const Text(
        'You are here',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: BioColors.ink,
        ),
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  /// Marker centers as fractions (0..1) of the paint area.
  final List<Offset> fractions;

  /// Index of the furthest reached node (0 = basecamp .. 6 = summit). The path
  /// up to this node is drawn highlighted; the rest is faded.
  final int reachedIndex;
  const _TrailPainter(this.fractions, this.reachedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final pts = fractions
        .map((f) => Offset(f.dx * size.width, f.dy * size.height))
        .toList();

    // A smooth path through all nodes using quadratic segments via midpoints.
    final full = _smoothPath(pts);

    // Faded "trail ahead" underlay.
    final ahead = Paint()
      ..color = BioColors.bark.withValues(alpha: 0.45)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(full, ahead);

    // Dashed centre line on the trail ahead for a "route" feel.
    _drawDashed(
      canvas,
      full,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Highlighted "conquered" portion up to the reached node.
    if (reachedIndex > 0) {
      final donePts = pts.sublist(0, (reachedIndex + 1).clamp(1, pts.length));
      if (donePts.length >= 2) {
        final done = _smoothPath(donePts);
        canvas.drawPath(
          done,
          Paint()
            ..color = BioColors.sun
            ..strokeWidth = 7.5
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }

    // Footprint dots along every segment for extra detail.
    final foot = Paint()..color = BioColors.bark.withValues(alpha: 0.4);
    for (var i = 0; i < pts.length - 1; i++) {
      final a = pts[i];
      final b = pts[i + 1];
      for (var t = 0.25; t < 1.0; t += 0.25) {
        final p = Offset.lerp(a, b, t)!;
        canvas.drawCircle(p, 2.4, foot);
      }
    }
  }

  Path _smoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    if (pts.length == 2) {
      path.lineTo(pts[1].dx, pts[1].dy);
      return path;
    }
    for (var i = 1; i < pts.length - 1; i++) {
      final mid = Offset(
        (pts[i].dx + pts[i + 1].dx) / 2,
        (pts[i].dy + pts[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  void _drawDashed(Canvas canvas, Path source, Paint paint) {
    const dash = 10.0;
    const gap = 8.0;
    for (final metric in source.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = math.min(dist + dash, metric.length);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) =>
      oldDelegate.fractions != fractions ||
      oldDelegate.reachedIndex != reachedIndex;
}

/// A simple north-pointing compass rose.
class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    // North needle (red).
    final north = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx - 6, c.dy)
      ..lineTo(c.dx + 6, c.dy)
      ..close();
    canvas.drawPath(north, Paint()..color = BioColors.danger);
    // South needle (dark).
    final south = Path()
      ..moveTo(c.dx, c.dy + r)
      ..lineTo(c.dx - 6, c.dy)
      ..lineTo(c.dx + 6, c.dy)
      ..close();
    canvas.drawPath(south, Paint()..color = BioColors.ink);
    canvas.drawCircle(c, 3, Paint()..color = Colors.white);

    final tp = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: BioColors.danger,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - r - tp.height + 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cheap pulsing highlight for the next available station.
class _Pulse extends StatefulWidget {
  final Widget child;
  final bool enabled;
  const _Pulse({required this.child, required this.enabled});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return ScaleTransition(
      scale: Tween(
        begin: 1.0,
        end: 1.12,
      ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: widget.child,
    );
  }
}

/// Animated dashed trail with chevrons pointing toward the next station.
class _TrailGuideOverlay extends StatefulWidget {
  final Offset from;
  final Offset to;

  const _TrailGuideOverlay({required this.from, required this.to});

  @override
  State<_TrailGuideOverlay> createState() => _TrailGuideOverlayState();
}

class _TrailGuideOverlayState extends State<_TrailGuideOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _TrailGuidePainter(
          from: widget.from,
          to: widget.to,
          phase: _c.value,
        ),
      ),
    );
  }
}

class _TrailGuidePainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final double phase;

  const _TrailGuidePainter({
    required this.from,
    required this.to,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = BioColors.sun.withValues(alpha: 0.85)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(from, to, pathPaint);

    final dir = (to - from);
    final length = dir.distance;
    if (length < 1) return;
    final unit = dir / length;
    final normal = Offset(-unit.dy, unit.dx);

    for (var i = 0; i < 4; i++) {
      final t = ((i / 4) + phase) % 1.0;
      final center = Offset.lerp(from, to, t)!;
      final tip = center + unit * 14;
      final wing = normal * 8;
      final arrow = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(
          center.dx - unit.dx * 6 + wing.dx,
          center.dy - unit.dy * 6 + wing.dy,
        )
        ..lineTo(
          center.dx - unit.dx * 6 - wing.dx,
          center.dy - unit.dy * 6 - wing.dy,
        )
        ..close();
      canvas.drawPath(
        arrow,
        Paint()
          ..color = BioColors.sun.withValues(alpha: 0.55 + (1 - t) * 0.35)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrailGuidePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.from != from ||
      oldDelegate.to != to;
}

/// Blinking ring around the guided station marker.
class _GuideRing extends StatefulWidget {
  final Widget child;

  const _GuideRing({required this.child});

  @override
  State<_GuideRing> createState() => _GuideRingState();
}

class _GuideRingState extends State<_GuideRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final blink = 0.35 + _c.value * 0.65;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: BioColors.sun.withValues(alpha: blink),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: BioColors.sun.withValues(alpha: blink * 0.45),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
