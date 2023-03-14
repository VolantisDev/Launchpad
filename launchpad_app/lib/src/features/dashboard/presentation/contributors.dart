import 'package:fluent_ui/fluent_ui.dart';
import 'package:launchpad_app/src/features/dashboard/domain/contributor.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/contributor.dart';
import 'package:url_launcher/link.dart';

import 'sponsor.dart';

class Contributors extends StatelessWidget {
  const Contributors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('CONTRIBUTORS', style: theme.typography.bodyStrong),
        const SizedBox(width: 4.0),
        const Icon(FluentIcons.branch_pull_request, size: 16.0),
      ]),
      const SizedBox(height: 4.0),
      Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: <Widget>[
          ...contributors.map((contributor) {
            return Link(
              uri: Uri.parse('https://www.github.com/${contributor.username}'),
              builder: (context, open) {
                return IconButton(
                  onPressed: open,
                  icon: ContributorButton(
                    imageUrl: contributor.imageUrl,
                    username: contributor.username ?? contributor.name,
                  ),
                );
              },
            );
          }),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ContributorDialog(),
              );
            },
            icon: Column(children: [
              SizedBox(
                height: 45,
                width: 45,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      colors: [
                        theme.accentColor.lighter,
                        theme.accentColor.normal,
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: const Icon(FluentIcons.robot, size: 45),
                ),
              ),
              const Text('Your mug here'),
            ]),
          ),
        ],
      ),
    ]);
  }
}

class ContributorButton extends StatelessWidget {
  const ContributorButton({
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
        height: 45,
        width: 45,
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
