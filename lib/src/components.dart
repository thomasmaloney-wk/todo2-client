import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/components/app.dart';
import 'package:w_module/w_module.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'actions.dart';
import 'components/local_shell.dart';
import 'components/todo_list_filter_sidebar.dart';
import 'store.dart';

class TodoComponents extends ModuleComponents {
  TodoActions _actions;
  TodoStore _store;

  TodoComponents(this._actions, this._store);

  @override
  Object content({String currentUserId = '', bool withFilter = true}) {
    //return Dom.div()('hi');
    return (TodoApp()
      ..actions = _actions
      ..store = _store
      ..currentUserId = currentUserId
      ..withFilter = withFilter
    )();
  }

  dynamic localShell() => TodoLocalShell()(content());

  dynamic sidebar() => (TodoListFilterSidebar()
    ..actions = _actions
    ..store = _store
  )();
}
