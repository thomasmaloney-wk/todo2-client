import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/actions.dart';
import 'package:todo2_client/src/store.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'create_todo_input.dart';
import 'todo_list.dart';
import 'todo_list_fab.dart';
import 'todo_list_filter.dart';

// ignore: uri_has_not_been_generated
part 'app.over_react.g.dart';

UiFactory<TodoAppProps> TodoApp = _$TodoApp; // ignore: undefined_identifier

mixin TodoAppPropsMixin on UiProps {
  String currentUserId;
  bool withFilter;
}

class TodoAppProps = UiProps
    with FluxUiPropsMixin<TodoActions, TodoStore>, TodoAppPropsMixin;

class TodoAppComponent extends FluxUiComponent2<TodoAppProps> {
  @override
  get defaultProps => (newProps()
    ..currentUserId = ''
    ..withFilter = true
  );

  @override
  render() {
    var createTodoInput;
    var todoListFilter;
    var todoList;

    createTodoInput = (BlockContent()
      ..shrink = true
      ..addTestId('app.createTodoInputWrapper')
    )(
      (CreateTodoInput()
        ..actions = props.actions
        ..addTestId('app.createTodoInput')
      )(),
    );

    if (props.withFilter) {
      todoListFilter = (BlockContent()
        ..collapse = BlockCollapse.VERTICAL
        ..shrink = true
      )(
        (TodoListFilter()
          ..actions = props.actions
          ..includeComplete = props.store.includeComplete
          ..includeIncomplete = props.store.includeIncomplete
          ..includePrivate = props.store.includePrivate
          ..includePublic = props.store.includePublic
        )(),
      );
    }

    todoList = (Block()
      // Add a top gutter and collapse the content's top padding
      // so that there's still space above when the content is scrolled.
      ..gutter = BlockGutter.TOP
      ..addTestId('app.listAndFabWrapper')
    )(
      (BlockContent()
        ..collapse = BlockCollapse.TOP
        ..addTestId('app.listWrapper')
      )(
        (TodoList()
          ..actions = props.actions
          ..activeTodo = props.store.activeTodo
          ..currentUserId = props.currentUserId
          ..todos = props.store.todos
          ..addTestId('app.todoList')
        )(),
      ),
      (TodoListFab()
        ..actions = props.actions
        ..store = props.store
        ..addTestId('app.todoListFab')
      )(),
    );

    return (VBlock()
      ..className = 'todo-app'
      ..addTestId('app.mainContent')
    )(
      createTodoInput,
      todoListFilter,
      todoList,
    );
  }
}
