import 'package:flutter/material.dart';

/// Observes navigation so screens can auto-narrate whenever they become visible.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();
