import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/game_platforms/application/game_platform_types.dart';
import 'package:launchpad_app/src/features/games/domain/game.dart';
import 'package:launchpad_app/src/utils/theme_provider.dart';

class GameListing extends StatefulHookConsumerWidget {
  const GameListing(
    this.games, {
    Key? key,
  }) : super(key: key);

  final List<Game> games;

  @override
  ConsumerState<GameListing> createState() => _GameListing();
}

class _GameListing extends ConsumerState<GameListing> {
  bool selected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var spacing = 16.0;
      var spacingWidth = spacing * 1.5;
      var minWidth = 75.0;
      var maxWidth = 200.0;
      var minItemsPerRow = 3;
      var maxContainerWidth = (constraints.maxWidth + spacingWidth - 1);
      var itemsPerRow = maxContainerWidth ~/ (maxWidth + spacingWidth);
      var itemWidth =
          (maxContainerWidth - (itemsPerRow * spacingWidth)) / (itemsPerRow);
      var textSize = 16.0;
      var minTextSize = 13.0;

      if (itemWidth > maxWidth) {
        itemsPerRow = itemsPerRow + 1;
        itemWidth =
            (maxContainerWidth - (itemsPerRow * spacingWidth)) / itemsPerRow;
      }

      if (itemsPerRow < minItemsPerRow) {
        itemsPerRow = minItemsPerRow;
        itemWidth =
            (maxContainerWidth - (itemsPerRow * spacingWidth)) / itemsPerRow;
      }

      if (itemWidth > maxWidth) {
        itemWidth = maxWidth;
        itemsPerRow = maxContainerWidth ~/ (itemWidth + spacingWidth);
      }

      var multiplier = itemWidth / maxWidth;
      textSize = textSize * multiplier;

      if (textSize < minTextSize) {
        textSize = minTextSize;
      }

      return Wrap(
        spacing: spacingWidth,
        runSpacing: spacing,
        children: [
          for (var game in widget.games)
            PackshotGameListingItem(game, itemWidth, textSize: textSize),
        ],
      );
    });
  }
}

class PackshotGameListingItem extends HookConsumerWidget {
  const PackshotGameListingItem(
    this.game,
    this.width, {
    Key? key,
    this.textSize = 16,
  }) : super(key: key);

  final Game game;
  final double width;
  final double textSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(appThemeProvider);
    var platformTypes = ref.watch(gamePlatformTypesProvider);

    var platformType = (platformTypes.hasValue && platformTypes.value != null)
        ? platformTypes.value![game.platformId]
        : null;

    var platformIcon =
        (platformType != null) ? platformType.locateIcon() : Future.value(null);

    var platformName =
        (platformType != null) ? platformType.name : game.platformId;

    return FutureBuilder<Widget?>(
        future: platformIcon,
        builder: (context, snapshot) {
          return Container(
            width: width,
            child: AspectRatio(
              aspectRatio: 9 / 14,
              child: Container(
                color: theme.color.darker,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        File(
                            'E:/Tools/Launchpad - Assets/Games/Overwatch/background_art.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              game.name,
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.8),
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (snapshot.hasData && snapshot.data != null)
                              snapshot.data!,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
