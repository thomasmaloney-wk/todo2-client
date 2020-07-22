import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:web_skin_dart/ui_components.dart';

import '../actions.dart';

// ignore: uri_has_not_been_generated
part 'create_todo_input.over_react.g.dart';

UiFactory<CreateTodoInputProps> CreateTodoInput =
    _$CreateTodoInput; // ignore: undefined_identifier

mixin CreateTodoInputProps on UiProps {
  TodoActions actions;
}

mixin CreateTodoInputState on UiState {
  String newTodoDescription;
}

class CreateTodoInputComponent
    extends UiStatefulComponent2<CreateTodoInputProps, CreateTodoInputState> {
  @override
  Map<dynamic, dynamic> get defaultProps => newProps();

  @override
  Map<dynamic, dynamic> get initialState =>
      (newState()..newTodoDescription = '');

  @override
  ReactElement render() {
    return (Form()
      ..className = 'create-todo-input'
      ..onSubmit = _createTodo
      ..addTestId('createTodoInput.form')
    )(
      (TextInput()
        ..autoFocus = true
        ..hideLabel = true
        ..label = 'Create a Todo'
        ..onChange = _updateNewTodoDescription
        ..placeholder = 'What do you need to do?'
        ..size = InputSize.LARGE
        ..value = state.newTodoDescription
        ..addTestId('createTodoInput.input')
      )(),
    );
  }

  void _createTodo(_) {
    var todo = Todo(description: state.newTodoDescription);
    props.actions.createTodo(todo);
    setState(newState()..newTodoDescription = '');
  }

  _updateNewTodoDescription(e) {
    setState(
        newState()..newTodoDescription = (e.target as TextInputElement).value
        );
  }
}
