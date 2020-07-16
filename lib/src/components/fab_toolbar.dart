import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:web_skin_dart/ui_components.dart';

// ignore: uri_has_not_been_generated
part 'fab_toolbar.over_react.g.dart';

UiFactory<FabToolbarProps> FabToolbar =
    _$FabToolbar; // ignore: undefined_identifier

mixin FabToolbarProps on UiProps {
  dynamic buttonContent;
}

mixin FabToolbarState on UiState {
  bool isOpen;
}

class FabToolbarComponent
    extends UiStatefulComponent2<FabToolbarProps, FabToolbarState>
    with RootCloseHandlersMixin {
  @override
  get defaultProps => (newProps());

  @override
  get initialState => (newState()..isOpen = false);

  @override
  getSnapshotBeforeUpdate(Map prevProps, Map prevState) {
    super.getSnapshotBeforeUpdate(prevProps, prevState);

    var tNextState = typedStateFactory(state);
    tNextState.isOpen ? bindRootCloseHandlers() : unbindRootCloseHandlers();
  }

  @override
  void componentWillUnmount() {
    super.componentWillUnmount();
    unbindRootCloseHandlers();
  }

  @override
  render() {
    var classes = forwardingClassNameBuilder()
      ..add('fab-toolbar fab-toolbar--primary')
      ..add('fab-toolbar--open', state.isOpen)
      ..blacklist('btn');

    return (Button()
      ..skin = ButtonSkin.VANILLA
      ..className = classes.toClassName()
      ..classNameBlacklist = classes.toClassNameBlacklist()
      ..onClick = (_) {
        toggle();
      }
      ..addTestId('fabToolbar.button')
    )(
      (Dom.div()
        ..className = 'fab-toolbar__content'
        ..addTestId('fabToolbar.content')
      )(props.buttonContent),
      (Dom.div()
        ..className = 'fab-toolbar--open__content'
        ..addTestId('fabToolbar.openContent')
      )(
        (Block()
          ..scroll = true
          ..align = BlockAlign.CENTER
          ..addTestId('fabToolbar.openContentBlock')
        )(
          (ToggleButtonGroup()
            ..size = ButtonGroupSize.LARGE
            ..skin = ButtonSkin.LINK
            ..hideGroupLabel = true
            ..groupLabel = 'Filter Options'
            ..addTestId('fabToolbar.toggleButtonGroup')
          )(
            props.children,
          ),
        ),
      ),
    );
  }

  void toggle() => setState(newState()..isOpen = !state.isOpen);

  void close() => setState(newState()..isOpen = false);

  void open() => setState(newState()..isOpen = true);

  @override
  void handleCapturingDocumentFocus(FocusEvent event) {
    if (event.target is! Element || !findDomNode(this).contains(event.target)) {
      close();
    }
  }

  @override
  void handleDocumentClick(MouseEvent event) {
    if (event.target is Element && !findDomNode(this).contains(event.target)) {
      close();
    }
  }

  @override
  void handleDocumentKeyDown(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      close();
    }
  }
}
