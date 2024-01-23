import 'dart:math';

import 'package:flutter/material.dart';

import '../../../src/utilities/functions/shortcuts.dart';
import '../../../src/utilities/skeleton_loader.dart';
import 'custom_container_transform.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.widget,
    this.isPlaceholder = false,
  });

  final String title;
  final String content;
  final IconData? icon;
  final Widget? widget;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final textTheme = widget != null
        ? Theme.of(context).primaryTextTheme
        : Theme.of(context).textTheme;

    return CustomContainerTransform(
      openWidget: widget,
      closedBuilder: (context, _) {
        return isPlaceholder
            ? _buildSkeleton(context)
            : Card(
                color: widget != null
                    ? getCustomOnPrimaryColor(context).withOpacity(0.7)
                    : getPrimaryColor(context),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleLarge!.apply(
                          fontWeightDelta: 2,
                          color: getAppColorScheme(context).onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: textTheme.bodyMedium?.copyWith(
                          color: getAppColorScheme(context).onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        icon,
                        size: 32,
                        color: textTheme.bodyMedium!.color,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final rnd = Random();

    return SizedBox(
      height: 275,
      child: Card(
        color: widget != null
            ? getCustomOnPrimaryColor(context)
            : getPrimaryColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SkeletonLoader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < 5; i++) ...{
                  Container(
                    width: 130 - (20 + rnd.nextInt(40 - 20).toDouble()),
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 4),
                },
                const SizedBox(height: 12),
                Container(
                  width: 30,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
