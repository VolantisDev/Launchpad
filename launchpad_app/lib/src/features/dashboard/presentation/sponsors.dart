import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/link.dart';

import '../domain/sponsor.dart';
import 'sponsor.dart';

class Sponsors extends StatelessWidget {
  const Sponsors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                height: 45,
                width: 45,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      colors: [
                        theme.accentColor.normal,
                        theme.accentColor.lighter,
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: const Icon(FluentIcons.diamond_user, size: 45),
                ),
              ),
              const Text('Become a Sponsor!'),
            ]),
          ),
        ],
      ),
    ]);
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
