import 'package:over_react/over_react.dart';
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:web_skin_dart/ui_components.dart';

import '../actions.dart';

// ignore: uri_has_not_been_generated
part 'edit_todo_modal.over_react.g.dart';

@Factory()
UiFactory<EditTodoModalProps> EditTodoModal = 
    // ignore: undefined_identifier
    _$EditTodoModal; 

@Props()
class _$EditTodoModalProps extends ModalProps {
  TodoActions actions;
  Todo todo;
}

@Component2(subtypeOf: ModalComponent)
class EditTodoModalComponent extends UiComponent2<EditTodoModalProps> {
  TextInputComponent _titleInputRef;
  TextInputComponent _notesInputRef;

  @override
  render() {
    return (Modal()
      ..modifyProps(addUnconsumedProps)
      ..header = 'Edit Todo'
      ..addTestId('editTodoModal.modal')
    )(
      (Form()
        ..onSubmit = _save
        ..addTestId('editTodoModal.form')
      )(
        (DialogBody()..addTestId('editTodoModal.dialogBody'))(
          (TextInput()
            ..addTestId('editTodoModal.titleInput')
            ..label = 'Title'
            ..defaultValue = props.todo.description
            ..ref = (ref) {
              _titleInputRef = ref;
            }
          )(),
          (TextInput()
            ..addTestId('editTodoModal.notesInput')
            ..isMultiline = true
            ..placeholder = 'Notes'
            ..rows = 3
            ..defaultValue = props.todo.notes
            ..ref = (ref) {
              _notesInputRef = ref;
            }
          )(),
        ),
        (DialogFooter()..addTestId('editTodoModal.dialogFooter'))(
          (FormSubmitInput()
            ..skin = ButtonSkin.SUCCESS
            ..pullRight = true
            ..addTestId('editTodoModal.submitButton')
          )('Save')
        )
      )
    );
  }

  void _save(SyntheticFormEvent event) {
    final modifiedTodo = props.todo.change(
      description: _titleInputRef.getValue(),
      notes: _notesInputRef.getValue()
    );

    props.actions.updateTodo(modifiedTodo);
    if (props.onRequestHide != null) props.onRequestHide(event);
  }
}

// This will be removed once the transition to Dart 2 is complete.
class EditTodoModalProps extends _$EditTodoModalProps
    with
        // ignore: mixin_of_non_class, undefined_class
        _$EditTodoModalPropsAccessorsMixin {
  // ignore: const_initialized_with_non_constant_value, undefined_class, undefined_identifier
  static const PropsMeta meta = _$metaForEditTodoModalProps;
}