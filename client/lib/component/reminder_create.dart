part of 'component.dart';

class CreateAlarmComp implements StatefulComponent {
  String _name = '';

  int _theme = 0;

  final TwoDigitEditor _hourC = TwoDigitEditor(1, max: 24);

  final TwoDigitEditor _minuteC = TwoDigitEditor(0, max: 59);

  @override
  build(BuildContext context) {
    return div([
      clazz('createalarm'),
      div(clazz('createalarm-titlebar'), span('Create reminder')),
      div([
        clazz('createalarm-content'),
        div(
            clazz('createalarm-row'),
            div(clazz('createalarm-label'), 'Do'),
            textInput(clazz('createalarm-text-input'), #name,
                onKeyPress((Event e) {
                  _name = (e.element as html.TextInputElement).value;
                })), afterInsert((Change change) {
          (change.node as html.Element).focus();
          print('here');
        })),
        div(
            clazz('createalarm-row'),
            div(clazz('createalarm-label'), 'In'),
            div(
              clazz('duration-composite'),
              _hourC,
              div(clazz('twodigitedit-holder'), span(':')),
              _minuteC,
            )),
        div(
            clazz('createalarm-row'),
            div(clazz('createalarm-label'), 'Theme'),
            div(
              clazz('swatch-holder'),
              Theme.values.map((t) => new SwatchComp(t.color,
                  value: t.id,
                  onSelect: (_) => _theme = t.id,
                  isSelected: _theme == t.id)),
            )),
        div(
          clazz('buttons'),
          div(clazz('button', 'green'), 'Create', onClick(
                (_) async {
              overlay = await addTimeAlarm(TimeAlarm(
                  name: _name,
                  time: DateTime.now().add(
                      new Duration(hours: _hourC.value, minutes: _minuteC.value)),
                  theme: _theme));
            },
          )),
          div(clazz('button', 'red'), 'Close', onClick(
                (_) {
              overlay = null;
            },
          )),
        )
      ]),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is CreateAlarmComp) {
      _name = previous._name;
      _theme = previous._theme;
    }
    return null;
  }
}