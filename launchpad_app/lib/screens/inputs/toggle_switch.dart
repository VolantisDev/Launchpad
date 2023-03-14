import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:launchpad_app/src/common_widgets/card_highlight.dart';

class ToggleSwitchPage extends StatefulHookConsumerWidget {
  const ToggleSwitchPage({Key? key}) : super(key: key);

  @override
  createState() => _ToggleSwitchPageState();
}

class _ToggleSwitchPageState extends ConsumerState<ToggleSwitchPage>
    with PageMixin {
  var disabled = false;
  var firstValue = false;
  var secondValue = true;

  @override
  build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('ToggleSwitch'),
        commandBar: ToggleSwitch(
          checked: disabled,
          onChanged: (v) => setState(() => disabled = v),
          content: const Text('Disabled'),
        ),
      ),
      children: [
        const Text(
          'The toggle switch represents a physical switch that allows users to '
          'turn things on or off, like a light switch. Use toggle switch controls '
          'to present users with two mutually exclusive options (such as on/off), '
          'where choosing an option provides immediate results.',
        ),
        subtitle(content: const Text('A simple ToggleSwitch')),
        CardHighlight(
          codeSnippet: '''bool checked = false;

ToggleSwitch(
  checked: checked,
  onPressed: disabled ? null : (v) => setState(() => checked = v),
)''',
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: ToggleSwitch(
              checked: firstValue,
              onChanged:
                  disabled ? null : (v) => setState(() => firstValue = v),
              content: Text(firstValue ? 'On' : 'Off'),
            ),
          ),
        ),
        subtitle(
          content: const Text('A ToggleSwitch with custom header and content'),
        ),
        CardHighlight(
          codeSnippet: '''bool checked = false;

ToggleSwitch(
  checked: checked,
  onPressed: disabled ? null : (v) => setState(() => checked = v),
  content: Text(checked ? 'Working' : 'Do work'),
)''',
          child: Row(children: [
            InfoLabel(
              label: 'Header',
              child: ToggleSwitch(
                checked: secondValue,
                onChanged:
                    disabled ? null : (v) => setState(() => secondValue = v),
                content: Text(secondValue ? 'Working' : 'Do work'),
              ),
            ),
            if (secondValue)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ProgressRing(),
              )
          ]),
        ),
      ],
    );
  }
}
