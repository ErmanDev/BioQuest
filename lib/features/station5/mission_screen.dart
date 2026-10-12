import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../data/station5_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';
import '../station/widgets/mission_cards.dart';
import 'data_analysis_order_activity.dart';
import 'data_sort_activity.dart';
import 'hypothesis_writing_activity.dart';
import 'final_decision_activity.dart';
import 'interpretation_activity.dart';
import 'mean_bar_graph_activity.dart';

class Station5MissionScreen extends StatefulWidget {
  const Station5MissionScreen({super.key});

  @override
  State<Station5MissionScreen> createState() => _Station5MissionScreenState();
}

class _Station5MissionScreenState extends State<Station5MissionScreen> {
  static const _contentLeft = 0.24;
  static const _contentRight = 0.76;
  static const _contentTop = 0.02;
  static const _contentHeight = 0.86;

  bool _storyShown = true;
  int _phase = 0; // 0–5 activities, 6 done
  bool _orderDone = false;
  bool _sortDone = false;
  bool _hypothesisDone = false;
  bool _meanBarDone = false;
  bool _interpretDone = false;
  bool _finalDecisionDone = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation5MissionBackgroundAsset,
            label: 'Research Mission',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
            cacheWidth: 1280,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 6),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      final left = w * _contentLeft;
                      final width = w * (_contentRight - _contentLeft);
                      final top = h * _contentTop;
                      final height = h * _contentHeight;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: ClipRect(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 6, 12, 4),
                                child: _storyShown
                                    ? _story()
                                    : switch (_phase) {
                                        0 => _order(),
                                        1 => _sort(),
                                        2 => _hypothesis(),
                                        3 => _meanBar(),
                                        4 => _interpret(),
                                        5 => _finalDecision(),
                                        _ => _done(),
                                      },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go(stationHubRoute('station5')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _story() {
    return SingleChildScrollView(
      child: MissionStoryCard(
        title: 'Mission Story',
        story: kStation5MissionStory,
        startLabel: 'Start Activity',
        onStart: () => setState(() => _storyShown = false),
      ),
    );
  }

  Widget _order() {
    return DataAnalysisOrderActivity(
      onCompleted: (correctSteps) {
        if (!_orderDone) {
          setState(() {
            _orderDone = true;
            _score += correctSteps;
          });
        }
      },
      onNext: _orderDone ? () => setState(() => _phase = 1) : null,
    );
  }

  Widget _sort() {
    return DataSortActivity(
      onCompleted: (allCorrect) {
        if (!_sortDone) {
          setState(() {
            _sortDone = true;
            if (allCorrect) _score++;
          });
        }
      },
      onNext: _sortDone
          ? () {
              setState(() => _phase = 2);
            }
          : null,
    );
  }

  Widget _hypothesis() {
    return HypothesisWritingActivity(
      onCompleted: (hypothesisScore) {
        if (!_hypothesisDone) {
          setState(() {
            _hypothesisDone = true;
            _score += hypothesisScore;
          });
        }
      },
      onNext: () => setState(() => _phase = 3),
    );
  }

  Widget _meanBar() {
    return MeanBarGraphActivity(
      onCompleted: (meanBarScore) {
        if (!_meanBarDone) {
          setState(() {
            _meanBarDone = true;
            _score += meanBarScore;
          });
        }
      },
      onNext: () => setState(() => _phase = 4),
    );
  }

  Widget _interpret() {
    return InterpretationActivity(
      onCompleted: (interpretScore) {
        if (!_interpretDone) {
          setState(() {
            _interpretDone = true;
            _score += interpretScore;
          });
        }
      },
      onNext: () => setState(() => _phase = 5),
    );
  }

  Widget _finalDecision() {
    return FinalDecisionActivity(
      onCompleted: (decisionScore) {
        if (!_finalDecisionDone) {
          setState(() {
            _finalDecisionDone = true;
            _score += decisionScore;
          });
        }
      },
      onNext: () => setState(() => _phase = 6),
    );
  }

  Widget _done() {
    // Order activity scores 1 per correct step; sort, hypothesis, and
    // mean/bar graph score 1 each.
    final missionTotal =
        kStation5Steps.length +
        3 +
        kStation5InterpretationMaxScore +
        kStation5FinalDecisionMaxScore;
    return MissionCompleteCard(
      score: _score,
      total: missionTotal,
      message: _score == missionTotal
          ? 'Case solved, detective! You completed every research mission '
                'challenge from planning to your final statistical decision.'
          : 'Good analysis! Review your statistical decision and conclusion, '
                'then continue to the takeaway question.',
      onContinue: () async {
        final progress = context.read<ProgressService>();
        final router = GoRouter.of(context);
        await progress.saveMissionScore('station5', _score);
        router.go('/station5/takeaway');
      },
    );
  }
}
