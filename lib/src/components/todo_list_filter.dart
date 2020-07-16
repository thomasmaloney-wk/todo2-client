import 'package:over_react/over_react.dart';
import 'package:web_skin_dart/ui_components.dart';

import '../actions.dart';

// ignore: uri_has_not_been_generated
part 'todo_list_filter.over_react.g.dart';

UiFactory<TodoListFilterProps> TodoListFilter =
    _$TodoListFilter; // ignore: undefined_identifier

mixin TodoListFilterProps on UiProps {
  TodoActions actions;
  bool includeComplete;
  bool includeIncomplete;
  bool includePrivate;
  bool includePublic;
}

class TodoListFilterComponent extends UiComponent2<TodoListFilterProps> {
  @override
  get defaultProps => (newProps()
    ..includeComplete = false
    ..includeIncomplete = false
    ..includePrivate = false
    ..includePublic = false
  );

  @override
  render() {
    return (Dom.div()..className = 'todo-list__filter')(
      (ToggleInputGroup()
        ..groupLabel = 'Todo List Filters'
        ..hideGroupLabel = true
      )(
        (CheckboxInput()
          ..defaultChecked = props.includePrivate
          ..label = 'Your Todos'
          ..onChange = (_) => props.actions.toggleIncludePrivate()
        )(),
        (CheckboxInput()
          ..defaultChecked = props.includePublic
          ..label = 'Public Todos'
          ..onChange = (_) => props.actions.toggleIncludePublic()
        )(),
        (CheckboxInput()
          ..defaultChecked = props.includeIncomplete
          ..label = 'Unfinished Todos'
          ..onChange = (_) => props.actions.toggleIncludeIncomplete()
        )(),
        (CheckboxInput()
          ..defaultChecked = props.includeComplete
          ..label = 'Finished Todos'
          ..onChange = (_) => props.actions.toggleIncludeComplete()
        )(),
      ),
    );
  }
}
