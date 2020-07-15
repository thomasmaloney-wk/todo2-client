import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/actions.dart';
import 'package:todo2_client/src/store.dart';
import 'package:wdesk_sdk/truss.dart';
import 'package:web_skin_dart/ui_components/icon.dart';

// ignore: uri_has_not_been_generated
part 'todo_list_filter_sidebar.over_react.g.dart';

UiFactory<TodoListFilterSidebarProps> TodoListFilterSidebar = _$TodoListFilterSidebar; // ignore: undefined_identifier

mixin TodoListFilterSidebarPropsMixin on UiProps {}

class TodoListFilterSidebarProps = UiProps with FluxUiPropsMixin<TodoActions, TodoStore>, TodoListFilterSidebarPropsMixin;

class TodoListFilterSidebarComponent extends FluxUiComponent2<TodoListFilterSidebarProps> {
  @override
  get defaultProps => (newProps());

  @override
  render() { 
    return WorkspacesMenu()(
      (WorkspacesMenuItem()
        ..active = true
        ..icon = IconGlyph.TASK_CREATE
        ..text = 'Todo List'
      )()
    );
  }
}