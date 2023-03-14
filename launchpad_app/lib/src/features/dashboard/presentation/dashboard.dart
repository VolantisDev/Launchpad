import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/contributors.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/sponsors.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/tour_message.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/updated_message.dart';
import 'package:launchpad_app/src/utils/heading.dart';
import 'package:state_persistence/state_persistence.dart';

import '../../../common_widgets/page.dart';

class DashboardPage extends StatefulHookConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<DashboardPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

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
        header: PageHeader(
          title: Text(appHeading),
        ),
        children: [
          const UpdatedMessage(),
          TourMessage(key: GlobalKey()),
          const Sponsors(),
          const SizedBox(height: 22.0),
          const Contributors(),
        ],
      );
    });
  }
}
