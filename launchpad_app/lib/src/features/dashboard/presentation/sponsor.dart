import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';

class SponsorDialog extends HookConsumerWidget {
  const SponsorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(debugCheckHasFluentTheme(context));

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 600),
      title: Row(
        children: [
          const Icon(FluentIcons.diamond_user, size: 24.0),
          const SizedBox(width: 8.0),
          const Expanded(child: Text('Benefits')),
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
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text(
            "Monthly financial contributions of any amount are greatly appreciated and will help ensure Launchpad's continued sustainability and improvement."),
        const SizedBox(height: 22.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: _Tier(
                name: 'Sponsorship Benefits',
                price: 'Starting at \$1 per month',
                benefits: [
                  'Support free software',
                  'Priority support',
                  'Early access to new features',
                  'A slick Discord badge and exclusive role',
                  'Top sponsors get listed on the dashboard',
                ],
              ),
            )
          ],
        )
      ]),
      actions: [
        Link(
          uri: Uri.parse('https://github.com/sponsors/bmcclure'),
          builder: (context, open) => FilledButton(
            onPressed: open,
            child: const Text('Become a Sponsor'),
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
        const SizedBox(height: 15.0),
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
