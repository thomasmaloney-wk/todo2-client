import 'package:todo2_client/src/actions.dart';
import 'package:todo2_client/src/components.dart';
import 'package:todo2_client/src/components/edit_todo_modal.dart';
import 'package:todo2_client/src/store.dart';
import 'package:todo2_sdk/todo2_sdk.dart';

import 'package:w_module/w_module.dart';
import 'package:wdesk_sdk/modal_manager.dart';

class TodoModule extends Module {
  TodoActions _actions;
  TodoComponents _components;
  ModalManager _modalManager;
  TodoSdk _sdk;
  TodoStore _store;

  TodoModule(this._sdk, {ModalManager modalManager}) {
    _modalManager = modalManager ?? ModalManager();
    _actions = TodoActions();
    _store = TodoStore(_actions, _sdk);
    _components = TodoComponents(_actions, _store);

    _actions.editTodo.listen((todo) {
      _modalManager.show((EditTodoModal()
        ..actions = _actions
        ..todo = todo
      )());
    });
  }

  @override
  TodoComponents get components => _components;
}
