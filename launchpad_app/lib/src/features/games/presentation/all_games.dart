import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/games/domain/game.dart';
import 'package:launchpad_app/src/features/games/presentation/game_listing.dart';

import '../../../common_widgets/page.dart';

class AllGamesPage extends StatefulHookConsumerWidget {
  const AllGamesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AllGamesPage> createState() => _AllGamesState();
}

class _AllGamesState extends ConsumerState<AllGamesPage> with PageMixin {
  bool selected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final List<Game> games = [
      for (var i = 0; i < 100; i++)
        const Game(
          key: 'Overwatch',
          name: 'Overwatch 2',
          installDir: 'C:\\Program Files (x86)\\Overwatch',
          platformId: 'blizzard',
          exeFile: 'Overwatch.exe',
          platformRef: 'pro',
        ),
    ];

    return ScrollablePage(
      header: const PageHeader(
        title: Text("All Games"),
      ),
      children: [
        GameListing(games),
      ],
    );
  }
}
