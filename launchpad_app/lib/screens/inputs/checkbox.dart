import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/card_highlight.dart';
import 'package:launchpad_app/src/common_widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CheckBoxPage extends StatefulHookConsumerWidget {
  const CheckBoxPage({Key? key}) : super(key: key);

  @override
  createState() => _CheckBoxPageState();
}

class _CheckBoxPageState extends ConsumerState<CheckBoxPage> with PageMixin {
  var firstChecked = false;
  var firstDisabled = false;
  bool? secondChecked = false;
  var secondDisabled = false;
  var iconDisabled = false;
  @override
  build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Checkbox')),
      children: [
        const Text(
          'CheckBox controls let the user select a combination of binary options. In contrast, RadioButton controls allow the user to select from mutually exclusive options. The indeterminate state is used to indicate that an option is set for some, but not all, child options. Don\'t allow users to set an indeterminate state directly to indicate a third option.',
        ),
        subtitle(content: const Text('A 2-state Checkbox')),
        CardHighlight(
          codeSnippet: '''bool checked = false;

Checkbox(
  checked: checked,
  onPressed: disabled ? null : (v) => setState(() => checked = v),
)''',
          child: Row(children: [
            Checkbox(
              checked: firstChecked,
              onChanged: firstDisabled
                  ? null
                  : (v) => setState(() => firstChecked = v!),
              content: const Text('Two-state Checkbox'),
            ),
            const Spacer(),
            ToggleSwitch(
              checked: firstDisabled,
              onChanged: (v) {
                setState(() {
                  firstDisabled = v;
                });
              },
              content: const Text('Disabled'),
            ),
          ]),
        ),
        subtitle(content: const Text('A 3-state Checkbox')),
        CardHighlight(
          codeSnippet: '''bool checked = false;

Checkbox(
  checked: checked,
  onPressed: disabled ? null : (v) {
    setState(() {
      // if v (the new value) is true, then true
      // if v is false, then null (third state)
      // if v is null (was third state before), then false
      // otherwise (just to be safe), it's true
      checked = (v == true
        ? true
          : v == false
            ? null
              : v == null
                ? false
                  : true);
    });
  },
)''',
          child: Row(children: [
            Checkbox(
              checked: secondChecked,
              // checked: null,
              onChanged: secondDisabled
                  ? null
                  : (v) {
                      setState(() {
                        secondChecked = v == true
                            ? true
                            : v == false
                                ? null
                                : v == null
                                    ? false
                                    : true;
                      });
                    },
              content: const Text('Three-state Checkbox'),
            ),
            const Spacer(),
            ToggleSwitch(
              checked: secondDisabled,
              onChanged: (v) {
                setState(() {
                  secondDisabled = v;
                });
              },
              content: const Text('Disabled'),
            ),
          ]),
        ),
        subtitle(
          content: const Text('Using a 3-state Checkbox (TreeView)'),
        ),
        Card(
          child: TreeView(
            items: [
              TreeViewItem(
                content: const Text('Select all'),
                children: treeViewItems,
              ),
            ],
            selectionMode: TreeViewSelectionMode.multiple,
          ),
        ),
      ],
    );
  }

  final treeViewItems = [
    TreeViewItem(content: const Text('Option 1')),
    TreeViewItem(content: const Text('Option 2')),
    TreeViewItem(content: const Text('Option 3')),
  ];
}
