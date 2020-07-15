import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:web_skin_dart/ui_components.dart';

import '../actions.dart';
import '../store.dart';
import 'fab_toolbar.dart';

// ignore: uri_has_not_been_generated
part 'todo_list_fab.over_react.g.dart';

UiFactory<TodoListFabProps> TodoListFab = _$TodoListFab; // ignore: undefined_identifier

mixin TodoListFabProps on UiProps {
  TodoActions actions;
  TodoStore store;
}

class TodoListFabComponent extends UiComponent2<TodoListFabProps> {
  @override
  get defaultProps => (newProps());

  @override
  render() { 
    return (FabToolbar()
      ..modifyProps(addUnconsumedProps)
      ..buttonContent = (Icon()..glyph = IconGlyph.FILTER)()
      ..addTestId('todoListFab.fabToolbar')
    )(
      _renderFabButton(
          name: 'Your Todos',
          glyph: IconGlyph.USER,
          isActive: props.store.includePrivate,
          onChange: ((_) => props.actions.toggleIncludePrivate())),
      _renderFabButton(
          name: 'Public Todos',
          glyph: IconGlyph.USERS,
          isActive: props.store.includePublic,
          onChange: ((_) => props.actions.toggleIncludePublic())),
      _renderFabButton(
          name: 'Unfinished Todos',
          glyph: IconGlyph.TIE_OUT_UNTIED,
          isActive: props.store.includeIncomplete,
          onChange: ((_) => props.actions.toggleIncludeIncomplete())),
      _renderFabButton(
          name: 'Finished Todos',
          glyph: IconGlyph.TIE_OUT_TIED,
          isActive: props.store.includeComplete,
          onChange: ((_) => props.actions.toggleIncludeComplete())),
    );
  }

  ReactElement _renderFabButton({
    @required String name,
    @required bool isActive,
    @required FormEventCallback onChange,
    @required IconGlyph glyph,
  }) {
    return (OverlayTrigger()
      ..overlay2 = Tooltip()(name)
      ..placement = OverlayPlacement.TOP
      ..addTestId('todoListFab.overlayTrigger.${name.replaceAll(' ', '')}')
    )(
      (CheckboxButton()
        ..addProps(ariaProps()..label = name)
        ..noText = true
        ..checked = isActive
        ..onChange = onChange
        ..addTestId('todoListFab.button.${name.replaceAll(' ', '')}')
      )(
        (Icon()
          ..glyph = glyph
          ..addTestId('todoListFab.icon.${name.replaceAll(' ', '')}')
        )(),
      ),
    );
  }
}