import 'package:flutter/material.dart';

import '../../data/station5_data.dart';
import 'data_sort_item_art.dart';

/// Draggable sort card styled like the reference interactive sorting activity.
class DataSortItemCard extends StatelessWidget {
  final int itemIndex;
  final double fontSize;
  final bool ghost;

  const DataSortItemCard({
    super.key,
    required this.itemIndex,
    this.fontSize = 11,
    this.ghost = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = kStation5DataItems[itemIndex].label;
    return Opacity(
      opacity: ghost ? 0.45 : 1,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48, maxHeight: 56),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4EA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1C2E5E), width: 2),
        ),
        child: Row(
          children: [
            SizedBox(width: 48, child: DataSortItemArt(index: itemIndex)),
            Container(
              width: 1.5,
              height: 36,
              color: const Color(0xFF1C2E5E).withValues(alpha: 0.25),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C2E5E),
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
