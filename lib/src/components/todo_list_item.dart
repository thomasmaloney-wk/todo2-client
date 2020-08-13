import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/actions.dart';
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_components/list_group.dart';

// ignore: uri_has_not_been_generated
part 'todo_list_item.over_react.g.dart';

UiFactory<TodoListItemProps> TodoListItem =
    _$TodoListItem; // ignore: undefined_identifier

mixin TodoListItemProps on UiProps {
  TodoActions actions;
  String currentUserId;
  bool isExpanded;
  Todo todo;
}

mixin TodoListItemState on UiState {
  bool isHovered;
  bool isChildFocused;
}

class TodoListItemComponent
    extends UiStatefulComponent2<TodoListItemProps, TodoListItemState> {
  @override
  get defaultProps => (newProps()
    ..currentUserId = ''
    ..isExpanded = false
    ..todo = null
  );

  @override
  get initialState => (newState()
    ..isHovered = false
    ..isChildFocused = false
  );

  @override
  render() {
    final classes = forwardingClassNameBuilder()
      ..add('todo-list__item')
      ..add('todo-list__item--complete', props.todo.isCompleted)
      ..add('todo-list__item--incomplete', !props.todo.isCompleted)
      ..add('todo-list__item--expanded', props.isExpanded);

    return (ListGroupItem()
      ..className = classes.toClassName()
      ..onMouseEnter = _handleItemMouseEnter
      ..onMouseLeave = _handleItemMouseLeave
      ..onFocus = _handleChildFocus
      ..onBlur = _handleChildBlur
      ..addTestId('todoListItem.listGroupItem')
    )(
      Dom.div()(
        Block()(
          (Block()
            ..className =
                'todo-list__item__block todo-list__item__checkbox-block'
            ..shrink = true
            ..addTestId('todoListItem.checkboxBlock')
          )(
            _renderTaskCheckbox(),
          ),
          (BlockContent()
            ..className = 'todo-list__item__block todo-list__item__header-block'
            ..collapse = BlockCollapse.VERTICAL
            ..scroll = false
            ..overflow = true
            ..addTestId('todoListItem.headerBlockContent')
          )(
            _renderTaskHeader(),
          ),
          (BlockContent()
            ..className = 'todo-list__item__block todo-list__item__labels-block'
            ..collapse = BlockCollapse.ALL
            ..shrink = true
            ..overflow = true
            ..addTestId('todoListItem.labelsBlockContent')
          )(
            _renderTaskLabels(),
          ),
          (BlockContent()
            ..className =
                'todo-list__item__block todo-list__item__controls-block'
            ..collapse = BlockCollapse.VERTICAL | BlockCollapse.RIGHT
            ..shrink = true
            ..overflow = true
            ..addTestId('todoListItem.controlsBlockContent')
          )(
            _renderTaskControlsToolbar(),
          ),
        ),
      ),
      _renderTaskNotes(),
    );
  }

  ReactElement _renderTaskCheckbox() {
    return (CheckboxInput()
      ..checked = props.todo.isCompleted
      ..isDisabled = !_canModify
      ..label = 'Complete Task'
      ..hideLabel = true
      ..value = ''
      ..onChange = _toggleCompletion
      ..addTestId('todoListItem.completeCheckbox')
    )();
  }

  ReactElement _renderTaskHeader() {
    return (Dom.div()
      ..role = Role.button
      ..onClick = _toggleExpansion
      ..addTestId('todoListItem.header')
    )(
      props.todo.description,
    );
  }

  ReactElement _renderTaskLabels() {
    return (Label()..addTestId('todoListItem.label'))(
      props.todo.isPublic ? 'public' : 'private',
    );
  }

  ReactElement _renderTaskNotes() {
    if (!props.isExpanded) return null;
    return (Dom.div()
      ..className = 'todo-list__item__notes'
      ..addTestId('todoListItem.row2')
    )(
      Dom.div()(
        _hasNotes
            ? props.todo.notes
            : (Dom.em()..className = 'text-muted')('No notes.'),
      ),
      Dom.div()(
        (Dom.em()
          ..className = 'text-muted'
        )('Account ID: ${props.todo.accountID}'),
      ),
    );
  }

  ReactElement _renderTaskControlsToolbar() {
    _buttonFactory() => Button()
      ..skin = ButtonSkin.VANILLA
      ..size = ButtonSize.XSMALL
      ..noText = true;

    final edit = (_buttonFactory()
      ..className = 'todo-list__item__edit-btn'
      ..onClick = _edit
      ..isDisabled = !_canModify
      ..addTestId('todoListItem.editButton')
    )(
      (Icon()..glyph = IconGlyph.PENCIL)(),
    );

    final privacy = (_buttonFactory()
      ..className = 'todo-list__item__privacy-btn'
      ..onClick = _togglePrivacy
      ..isDisabled = !_canModify || props.todo.isCompleted
      ..addTestId('todoListItem.privacyButton')
    )(
      (Icon()
        ..glyph =
            props.todo.isPublic ? IconGlyph.EYE_SHOW : IconGlyph.EYE_HIDE
      )(),
    );

    final delete = (_buttonFactory()
      ..className = 'todo-list__item__delete-btn'
      ..onClick = _delete
      ..isDisabled = !_canModify || props.todo.isCompleted
      ..addTestId('todoListItem.deleteButton')
    )(
      (Icon()..glyph = IconGlyph.TRASH)(),
    );

    return (ButtonToolbar()
      ..className = 'todo-list__item__controls-toolbar'
      ..addProps(ariaProps()..hidden = !_isHovered)
      ..addTestId('todoListItem.buttonToolbar')
    )(
      edit,
      privacy,
      delete,
    );
  }

  bool get _canModify =>
      props.currentUserId == null || props.currentUserId == props.todo.userID;
  bool get _hasNotes => props.todo?.notes?.isNotEmpty ?? false;
  bool get _isHovered => state.isHovered || state.isChildFocused;

  void _delete(_) {
    props.actions.deleteTodo(props.todo);
  }

  void _edit(_) {
    props.actions.editTodo(props.todo);
  }

  void _togglePrivacy(_) {
    final newPrivacy = !props.todo.isPublic;
    props.actions.updateTodo(props.todo.change(isPublic: newPrivacy));
  }

  void _toggleExpansion(SyntheticMouseEvent event) {
    event.stopPropagation();
    props.actions.selectTodo(props.isExpanded ? null : props.todo);
  }

  void _toggleCompletion(SyntheticFormEvent event) {
    final newCompletionStatus = !props.todo.isCompleted;
    props.actions
        .updateTodo(props.todo.change(isCompleted: newCompletionStatus));
  }

  void _handleItemMouseEnter(SyntheticMouseEvent event) {
    setState(newState()..isHovered = true);
  }

  void _handleItemMouseLeave(SyntheticMouseEvent event) {
    setState(newState()..isHovered = false);
  }

  void _handleChildFocus(SyntheticFocusEvent event) {
    setState(newState()..isChildFocused = true);
  }

  void _handleChildBlur(SyntheticFocusEvent event) {
    final newlyFocusedTarget = event.relatedTarget;
    if (newlyFocusedTarget is Element &&
        findDomNode(this).contains(newlyFocusedTarget)) {
      return;
    }

    setState(newState()..isChildFocused = false);
  }
}
