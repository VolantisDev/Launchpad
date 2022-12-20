import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/card_highlight.dart';
import 'package:launchpad_app/src/common_widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ContentDialogPage extends StatefulHookConsumerWidget {
  const ContentDialogPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ContentDialogPage> createState() => _ContentDialogPageState();
}

class _ContentDialogPageState extends ConsumerState<ContentDialogPage>
    with PageMixin {
  String? result = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('ContentDialog')),
      children: [
        const Text(
          'Dialog controls are modal UI overlays that provide contextual app '
          'information. They block interactions with the app window until being '
          'explicitly dismissed. They often request some kind of action from the '
          'user.',
        ),
        subtitle(content: const Text('A basic content dialog with content')),
        CardHighlight(
          codeSnippet: '''Button(
  child: const Text('Show dialog'),
  onPressed: () => showContentDialog(context),
),

void showContentDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('Delete file permanently?'),
      content: const Text(
        'If you delete this file, you won't be able to recover it. Do you want to delete it?',
      ),
      actions: [
        Button(
          child: const Text('Delete'),
          onPressed: () {
            Navigator.pop(context, 'User deleted file');
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );
  setState(() {});
}''',
          child: Row(children: [
            Button(
              child: const Text('Show dialog'),
              onPressed: () => showContentDialog(context),
            ),
            const SizedBox(width: 10.0),
            Text(result ?? ''),
            const Spacer(),
          ]),
        ),
      ],
    );
  }

  void showContentDialog(BuildContext context) async {
    result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Delete file permanently?'),
        content: const Text(
          'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
        ),
        actions: [
          Button(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context, 'User deleted file');
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, 'User canceled dialog'),
          ),
        ],
      ),
    );
    setState(() {});
  }
}
