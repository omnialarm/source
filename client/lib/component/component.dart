import 'dart:html' as html;
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:server/models/models.dart';
import 'package:client/api/api.dart';

part 'reminder_item.dart';
part 'reminder_list.dart';
part 'reminder_view.dart';
part 'reminder_create.dart';

class TopBar implements Component {
  @override
  build(BuildContext context) {
    return div([
      clazz('topbar'),
      div([
        clazz('topbar-title-holder'),
        div([clazz('topbar-title-icon')]),
        div([
          clazz('topbar-title'),
          span([clazz('title-omni'), 'Omni']),
          span([clazz('title-alarm'), 'Alarm'])
        ]),
      ]),
      div([
        clazz('topbar-actions'),
        div(clazz('topbar-action'), '+', onClick((_) => overlay = 'create')),
      ]),
    ]);
  }
}

typedef void ValueCallback<T>(T v);

class SwatchComp<T> implements Component {
  final String color;

  final bool isSelected;

  final ValueCallback<T> onSelect;

  final T value;

  SwatchComp(this.color, {this.isSelected: false, this.onSelect, this.value});

  @override
  build(BuildContext context) {
    return div(clazz('swatch'), clazzIf(isSelected, 'selected'), bgColor(color),
        when(onSelect != null, onClick((_) => onSelect(value))));
  }
}

class TwoDigitEditor implements StatefulComponent {
  int value = 0;

  final int max;

  TwoDigitEditor(this.value, {this.max: 100});

  @override
  build(BuildContext context) {
    return div(clazz('twodigitedit-holder'), attr('tabIndex', '0'),
        onKeyDown((Event e) {
      html.KeyboardEvent ke = e.event;
      if (ke.keyCode >= 48 && ke.keyCode <= 57) {
        value = value * 10 + (ke.keyCode - 48);
        value %= 100;

        if (value > max) value %= 10;
      } else if (ke.keyCode == html.KeyCode.UP) {
        value++;
        value %= 100;

        if (value > max) value %= 10;
      } else if (ke.keyCode == html.KeyCode.DOWN) {
        if (value > 0) value--;
        value %= 100;

        if (value > max) value %= 10;
      }
    }), span(clazz('number'), _1(value)), span(clazz('number'), _0(value)));
  }

  @override
  Component restoreState(Component previous) {
    if (previous is TwoDigitEditor) value = previous.value;
    return this;
  }
}

String _0(int value) => (value % 10).toString();

String _1(int value) => ((value ~/ 10) % 10).toString();
