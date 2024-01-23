import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../widget/link_card.dart';
import '../widget/text_divider.dart';
import '../widget/theme_customizer.dart';
import '../widget/grid_item.dart';

class SettingsAndInformationScreen extends StatelessWidget {
  const SettingsAndInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'Theme',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const ThemeCustomizer(),
          const SizedBox(height: 48),
          LinkCard(
            title: 'Github Repository',
            icon: MdiIcons.github,
            url: Uri.parse(
              'https://github.com/Sir-Nath/NotesApp',
            ),
          ),
          const TextDivider(text: 'Peter Nath'),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2 / 1.15,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              GridItem(
                title: 'LinkedIn',
                icon: MdiIcons.linkedin,
                url: Uri.parse(
                  'https://www.linkedin.com/in/peter-nathaniel-455425215/',
                ),
              ),
              GridItem(
                title: 'Twitter',
                icon: MdiIcons.twitter,
                url: Uri.parse('https://twitter.com/Sir__Nath'),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
