import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/components/todo_list_item.dart';
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:web_skin_dart/ui_components.dart';

import '../actions.dart';

// ignore: uri_has_not_been_generated
part 'todo_list.over_react.g.dart';

UiFactory<TodoListProps> TodoList = _$TodoList; // ignore: undefined_identifier

mixin TodoListProps on UiProps {
  List<Todo> todos;
  Todo activeTodo;
  TodoActions actions;
  String currentUserId;
}

class TodoListComponent extends UiComponent2<TodoListProps> {
  @override
  Map<dynamic, dynamic> get defaultProps => (newProps()
    ..todos = const []
    ..currentUserId = ''
  );

  @override
  ReactElement render() {
    if (props.todos.isEmpty) {
      return (EmptyView()
        ..header = 'No todos to show'
        ..addTestId('todoList.emptyView')
      )(
        'Create one or adjust the filters.',
      );
    }

    final todoItems = props.todos.map((todo) => (TodoListItem()
      ..actions = props.actions
      ..currentUserId = props.currentUserId
      ..isExpanded = props.activeTodo == todo
      ..key = todo.id
      ..todo = todo
      ..addTestId('todoList.todoListItem.${todo.id}')
    )());

    return (ListGroup()
      ..className = 'todo-list'
      ..isBordered = true
      ..size = ListGroupSize.LARGE
      ..addTestId('todoList.listGroup')
    )(
      todoItems,
    );
  }
}
