import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';

class ContributorDialog extends HookConsumerWidget {
  const ContributorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(debugCheckHasFluentTheme(context));

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 600),
      title: Row(
        children: [
          const Icon(FluentIcons.rocket, size: 24.0),
          const SizedBox(width: 8.0),
          const Expanded(child: Text('Help Make it Happen')),
          SmallIconButton(
            child: Tooltip(
              message: FluentLocalizations.of(context).closeButtonLabel,
              child: IconButton(
                icon: const Icon(FluentIcons.chrome_close),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
        ],
      ),
      content: const Text(
          "Launchpad is free software, and creating it takes a lot of work. If you'd like to help out, you can contribute to the project on GitHub."),
      actions: [
        Link(
          uri: Uri.parse(
              'https://github.com/VolantisDev/Launchpad/blob/master/CONTRIBUTING.md'),
          builder: (context, open) => FilledButton(
            onPressed: open,
            child: const Text('Contribute to Launchpad'),
          ),
        ),
      ],
    );
  }
}

class _Tier extends StatelessWidget {
  const _Tier({
    Key? key,
    required this.name,
    required this.price,
    required this.benefits,
  }) : super(key: key);

  final String name;
  final String price;

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.typography.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(price, style: theme.typography.caption),
        const SizedBox(height: 20.0),
        ...benefits.map((benefit) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(end: 6.0, top: 9.0),
                child: Icon(FluentIcons.circle_fill, size: 4.0),
              ),
              Expanded(child: Text(benefit)),
            ],
          );
        }),
      ],
    );
  }
}
