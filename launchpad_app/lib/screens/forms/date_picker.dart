import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/card_highlight.dart';
import 'package:launchpad_app/src/common_widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DatePickerPage extends StatefulHookConsumerWidget {
  const DatePickerPage({Key? key}) : super(key: key);

  @override
  createState() => _DatePickerPageState();
}

class _DatePickerPageState extends ConsumerState<DatePickerPage>
    with PageMixin {
  DateTime? simpleTime;
  DateTime? hiddenTime;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('DatePicker')),
      children: [
        const Text(
          'Use a DatePicker to let users set a date in your app, for example to '
          'schedule an appointment. The DatePicker displays three controls for '
          'month, date, and year. These controls are easy to use with touch or '
          'mouse, and they can be styled and configured in several different ways.'
          '\n\nThe entry point displays the chosen date, and when the user '
          'selects the entry point, a picker surface expands vertically from the '
          'middle for the user to make a selection. The date picker overlays '
          'other UI; it doesn\'t push other UI out of the way.',
        ),
        subtitle(content: const Text('A simple DatePicker with a header')),
        CardHighlight(
          codeSnippet: '''DateTime? selected;

DatePicker(
  header: 'Pick a date',
  selected: selected,
  onChanged: (time) => setState(() => selected = time),
),''',
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DatePicker(
              header: 'Pick a date',
              selected: simpleTime,
              onChanged: (time) => setState(() => simpleTime = time),
            ),
          ),
        ),
        subtitle(content: const Text('A DatePicker with year hidden')),
        CardHighlight(
          codeSnippet: '''DateTime? selected;

DatePicker(
  selected: selected,
  onChanged: (time) => setState(() => selected = time),
  showYear: false,
),''',
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DatePicker(
              selected: hiddenTime,
              onChanged: (v) => setState(() => hiddenTime = v),
              showYear: false,
            ),
          ),
        ),
      ],
    );
  }
}
