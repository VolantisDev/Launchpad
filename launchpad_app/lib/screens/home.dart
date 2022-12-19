import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';

import '../models/sponsor.dart';
import '../widgets/changelog.dart';
import '../widgets/page.dart';
import '../widgets/sponsor.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Your Game Launching Multitool'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Link(
            uri: Uri.parse(
                'https://github.com/VolantisDev/Launchpad/tree/flutter'),
            builder: (context, open) => Tooltip(
              message: 'Source code',
              child: IconButton(
                icon: const Icon(FluentIcons.open_source, size: 24.0),
                onPressed: open,
              ),
            ),
          ),
        ]),
      ),
      children: [
        const SizedBox(height: 22.0),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => const Changelog(),
            );
          },
          icon: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s new in Launchpad 10',
                style: theme.typography.body
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text('Dec 17, 2022', style: theme.typography.caption),
              Text(
                'A brand new desktop app!',
                style: theme.typography.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22.0),
        Row(children: [
          Text('SPONSORS', style: theme.typography.bodyStrong),
          const SizedBox(width: 4.0),
          const Icon(FluentIcons.heart_fill, size: 16.0),
        ]),
        const SizedBox(height: 4.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            ...sponsors.map((sponsor) {
              return Link(
                uri: Uri.parse('https://www.github.com/${sponsor.username}'),
                builder: (context, open) {
                  return IconButton(
                    onPressed: open,
                    icon: SponsorButton(
                      imageUrl: sponsor.imageUrl,
                      username: sponsor.username ?? sponsor.name,
                    ),
                  );
                },
              );
            }),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SponsorDialog(),
                );
              },
              icon: Column(children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.8),
                          ...Colors.accentColors,
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.srcATop,
                    child: const Icon(FluentIcons.diamond_user, size: 60),
                  ),
                ),
                const Text('Become a Sponsor!'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}
