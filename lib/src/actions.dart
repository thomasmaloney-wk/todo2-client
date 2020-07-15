import 'package:todo2_sdk/todo2_sdk.dart' show Todo;
import 'package:w_flux/w_flux.dart';
import 'package:w_common/disposable.dart';

class TodoActions extends Disposable {
  final Action<Todo> createTodo = Action<Todo>();
  final Action<Todo> completeTodo = Action<Todo>();
  final Action<Todo> deleteTodo = Action<Todo>();
  final Action<Todo> editTodo = Action<Todo>();
  final Action<Todo> reopenTodo = Action<Todo>();
  final Action<Todo> selectTodo = Action<Todo>();  
  final Action<Null> toggleIncludeComplete = Action<Null>();
  final Action<Null> toggleIncludeIncomplete = Action<Null>();
  final Action<Null> toggleIncludePrivate = Action<Null>();
  final Action<Null> toggleIncludePublic = Action<Null>();
  final Action<Todo> updateTodo = Action<Todo>();

  TodoActions() {
    <Action<dynamic>>[
      createTodo,
      completeTodo,
      deleteTodo,
      editTodo,
      reopenTodo,
      selectTodo,
      toggleIncludeComplete,
      toggleIncludeIncomplete,
      toggleIncludePrivate,
      toggleIncludePublic,
      updateTodo
    ].forEach(manageDisposable);
  }
}