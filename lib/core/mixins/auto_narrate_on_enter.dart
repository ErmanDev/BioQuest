import 'package:flutter/material.dart';

import '../../app/route_observer.dart';
import '../../services/narration_helper.dart';

/// Auto-plays narration when the route is first shown or when the user returns
/// to it. Stops narration when another screen is pushed on top or when leaving.
mixin AutoNarrateOnEnter<T extends StatefulWidget> on State<T>, RouteAware {
  String? get autoNarrateText;

  bool get shouldAutoNarrate => true;

  int _narrateScheduleGeneration = 0;

  @override
  void initState() {
    super.initState();
    scheduleAutoNarrate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _cancelPendingNarration();
    if (mounted) {
      stopNarration(context);
    }
    super.dispose();
  }

  @override
  void didPush() => scheduleAutoNarrate();

  @override
  void didPop() {
    _cancelPendingNarration();
    if (mounted) {
      stopNarration(context);
    }
  }

  @override
  void didPopNext() {
    _cancelPendingNarration();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await stopNarration(context);
      if (!mounted) return;
      scheduleAutoNarrate();
    });
  }

  @override
  void didPushNext() {
    _cancelPendingNarration();
    if (mounted) {
      stopNarration(context);
    }
  }

  void _cancelPendingNarration() {
    _narrateScheduleGeneration++;
  }

  void scheduleAutoNarrate() {
    if (!shouldAutoNarrate) return;
    final text = autoNarrateText;
    if (text == null || text.trim().isEmpty) return;

    final generation = ++_narrateScheduleGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _narrateScheduleGeneration) return;
      autoNarrateIfEnabled(context, text);
    });
  }
}
