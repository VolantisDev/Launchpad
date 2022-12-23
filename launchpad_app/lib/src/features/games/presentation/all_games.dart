import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/contributors.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/sponsors.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/tour_message.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/updated_message.dart';
import 'package:state_persistence/state_persistence.dart';

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
    final theme = FluentTheme.of(context);

    return PersistedStateBuilder(builder: (context, snapshot) {
      return ScaffoldPage.scrollable(
        header: const PageHeader(
          title: Text("All Games"),
        ),
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var spacing = 16.0;
            var minWidth = 75.0;
            var maxWidth = 200.0;
            var minItemsPerRow = 4;
            var maxContainerWidth = (constraints.maxWidth + (spacing * 2) - 1);
            var itemsPerRow = maxContainerWidth ~/ (maxWidth + (spacing * 2));
            var itemWidth =
                (maxContainerWidth - (itemsPerRow * (spacing * 2))) /
                    (itemsPerRow);

            if (itemWidth > maxWidth) {
              itemsPerRow = itemsPerRow + 1;
              itemWidth = (maxContainerWidth - (itemsPerRow * (spacing * 2))) /
                  itemsPerRow;
            }

            if (itemsPerRow < minItemsPerRow) {
              itemsPerRow = minItemsPerRow;
              itemWidth = (maxContainerWidth - (itemsPerRow * (spacing * 2))) /
                  itemsPerRow;
            }

            if (itemWidth > maxWidth) {
              itemWidth = maxWidth;
              itemsPerRow = maxContainerWidth ~/ (itemWidth + (spacing * 2));
            }

            return Wrap(
              spacing: spacing * 2,
              runSpacing: spacing,
              children: [
                for (var i = 0; i < 100; i++)
                  Container(
                    width: itemWidth,
                    color: Colors.blue,
                    child: AspectRatio(
                      aspectRatio: 9 / 14,
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                  )
              ],
            );
          }),
          const SizedBox(height: 22.0),
          const Contributors(),
        ],
      );
    });
  }
}
