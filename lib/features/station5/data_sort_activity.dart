import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';
import 'data_sort_item_card.dart';

/// Activity 2 — drag each data item into the NEED or NOT NEEDED folder.
class DataSortActivity extends StatefulWidget {
  final void Function(bool allCorrect) onCompleted;
  final VoidCallback? onNext;

  const DataSortActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<DataSortActivity> createState() => _DataSortActivityState();
}

class _DataSortActivityState extends State<DataSortActivity> {
  static const _needZone = 0;
  static const _notNeedZone = 1;

  /// `null` = still in the tray; otherwise folder zone index.
  late final List<int?> _placement =
      List<int?>.filled(kStation5DataItems.length, null);
  int? _selectedItem;

  bool get _allPlaced => _placement.every((zone) => zone != null);

  bool get _allCorrect {
    for (var i = 0; i < kStation5DataItems.length; i++) {
      final zone = _placement[i];
      final need = kStation5DataItems[i].important;
      if (zone == null) return false;
      final inNeed = zone == _needZone;
      if (need != inNeed) return false;
    }
    return true;
  }

  List<int> _itemsInZone(int zone) => [
        for (var i = 0; i < _placement.length; i++)
          if (_placement[i] == zone) i,
      ];

  List<int> get _trayItems => [
        for (var i = 0; i < _placement.length; i++)
          if (_placement[i] == null) i,
      ];

  void _selectItem(int index) {
    setState(() {
      _selectedItem = _selectedItem == index ? null : index;
    });
  }

  void _placeItem(int index, int zone) {
    setState(() {
      _placement[index] = zone;
      _selectedItem = null;
    });
    if (_allPlaced) widget.onCompleted(_allCorrect);
  }

  void _returnToTray(int index) {
    setState(() {
      _placement[index] = null;
      _selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 4),
        _tipBar(),
        const SizedBox(height: 6),
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _folder(zone: _needZone, need: true)),
              const SizedBox(width: 8),
              Expanded(child: _folder(zone: _notNeedZone, need: false)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(flex: 4, child: _tray()),
        if (_allPlaced && widget.onNext != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              label: 'Next Activity',
              icon: Icons.arrow_forward,
              color: BioColors.forest,
              fontSize: 13,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              onTap: widget.onNext,
            ),
          ),
        ],
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          kStation5SortTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1565C0),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          kStation5SortQuestion.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: BioColors.ink,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _tipBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF59D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF9A825)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Color(0xFFF57F17), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              kStation5SortInstruction,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: BioColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _folder({required int zone, required bool need}) {
    final items = _itemsInZone(zone);
    final canDrop = _selectedItem != null;
    final accent = need ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final label =
        need ? kStation5SortNeedLabel : kStation5SortNotNeedLabel;

    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => _placeItem(details.data, zone),
      builder: (context, candidate, rejected) {
        final highlight = candidate.isNotEmpty || canDrop;
        return Material(
          color: need
              ? const Color(0xFFE8F5E9)
              : const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _selectedItem != null
                ? () => _placeItem(_selectedItem!, zone)
                : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: highlight ? accent : accent.withValues(alpha: 0.55),
                  width: highlight ? 2.5 : 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        need ? Icons.verified_user : Icons.cancel,
                        color: accent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: accent,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: items.isEmpty
                        ? _dropHint(accent, highlight)
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final index in items)
                                  _draggableItem(index, compact: true),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dropHint(Color accent, bool highlight) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent.withValues(alpha: highlight ? 0.9 : 0.45),
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Text(
        'Drag items here',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: accent.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  Widget _tray() {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => _placement[details.data] != null,
      onAcceptWithDetails: (details) => _returnToTray(details.data),
      builder: (context, candidate, rejected) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1565C0), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                kStation5SortTrayLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: _trayItems.isEmpty
                    ? Center(
                        child: Text(
                          'All items sorted!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: BioColors.ink.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final index in _trayItems)
                              _draggableItem(index),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _draggableItem(int index, {bool compact = false}) {
    final selected = _selectedItem == index;
    final card = DataSortItemCard(
      itemIndex: index,
      fontSize: compact ? 9.5 : 10.5,
    );

    return SizedBox(
      width: compact ? 168 : 176,
      child: LongPressDraggable<int>(
        data: index,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 176,
            child: DataSortItemCard(itemIndex: index, fontSize: 10.5),
          ),
        ),
        childWhenDragging: DataSortItemCard(
          itemIndex: index,
          fontSize: compact ? 9.5 : 10.5,
          ghost: true,
        ),
        child: GestureDetector(
          onTap: () => _selectItem(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: BioColors.forest.withValues(alpha: 0.45),
                        blurRadius: 0,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: card,
          ),
        ),
      ),
    );
  }
}
