import 'package:todo2_sdk/todo2_sdk.dart' show Todo, TodoSdk;
import 'package:w_flux/w_flux.dart';

import 'package:todo2_client/src/actions.dart';

class TodoStore extends Store {
  final TodoActions _actions;
  final TodoSdk _sdk;
  
  Map<String, Todo> _todosMap = {};

  String _activeTodoId;
  bool _includeComplete = true;
  bool _includeIncomplete = true;
  bool _includePrivate = true;
  bool _includePublic = true;

  TodoStore(this._actions, this._sdk) {
    _actions.createTodo.listen(_createTodo);
    _actions.deleteTodo.listen(_deleteTodo);
    _actions.updateTodo.listen(_updateTodo);
    triggerOnActionV2(_actions.selectTodo, _selectTodo);

    triggerOnActionV2(_actions.toggleIncludeComplete, (_) {
      _includeComplete = !_includeComplete;
      if (!_includeComplete) _includeIncomplete = true;
    });

    triggerOnActionV2(_actions.toggleIncludeIncomplete, (_) {
      _includeIncomplete = !_includeIncomplete;
      if (!_includeIncomplete) _includeComplete = true;
    });

    triggerOnActionV2(_actions.toggleIncludePublic, (_) {
      _includePublic = !_includePublic;
      if (!_includePublic) _includePrivate = true;
    });

    triggerOnActionV2(_actions.toggleIncludePrivate, (_) {
      _includePrivate = !_includePrivate;
      if (!_includePrivate) _includePublic = true;
    });

    _sdk.todoCreated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    });

    _sdk.todoDeleted.listen((todo) {
      _todosMap.remove(todo.id);
      trigger();
    });

    _sdk.todoUpdated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    });

    _initialize();
  }

  Todo get activeTodo => _todosMap[_activeTodoId];
  bool get includeComplete => _includeComplete;
  bool get includeIncomplete => _includeIncomplete;
  bool get includePrivate => _includePrivate;
  bool get includePublic => _includePublic;

  List<Todo> get todos {
    List<Todo> complete = [];
    List<Todo> incomplete = [];
    for (var todo in _todosMap.values) {
      if (!_sdk.userCanAccess(todo)) continue;
      if (!includeComplete && todo.isCompleted) continue;
      if (!includeIncomplete && !todo.isCompleted) continue;
      if (!includePrivate && !todo.isPublic) continue;
      if (!includePublic && todo.isPublic) continue;
      todo.isCompleted ? complete.add(todo) : incomplete.add(todo);
    }

    return []..addAll(incomplete.reversed)..addAll(complete.reversed);
  }

  bool canAccess(Todo todo) => _sdk.userCanAccess(todo);

  _createTodo(Todo todo) {
    _sdk.createTodo(todo);
  }

  _deleteTodo(Todo todo) {
    _sdk.deleteTodo(todo.id);
  }

  _updateTodo(Todo todo) {
    _sdk.updateTodo(todo);
  }

  _selectTodo(Todo todo) {
    _activeTodoId = todo?.id ?? null;
  }

  _initialize() async {
    _todosMap = new Map.fromIterable(
        await _sdk.queryTodos(
            includeComplete: true,
            includeIncomplete: true,
            includePrivate: true,
            includePublic: true),
        key: (todo) => todo.id);
    trigger();
  }
}