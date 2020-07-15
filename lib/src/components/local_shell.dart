import 'package:over_react/over_react.dart';
import 'package:web_skin_dart/ui_components.dart';

// ignore: uri_has_not_been_generated
part 'local_shell.over_react.g.dart';

UiFactory<TodoLocalShellProps> TodoLocalShell = _$TodoLocalShell; // ignore: undefined_identifier

mixin TodoLocalShellProps on UiProps {}

class TodoLocalShellComponent extends UiComponent2<TodoLocalShellProps> {
  @override
  get defaultProps => (newProps());

  @override
  render() {
    return (GridFrame()..addTestId('todoLocalShell.gridFrame'))(
      (VBlock()..addTestId('todoLocalShell.vBlock'))(
        (BlockContent()
          ..className = 'login-prompt'
          ..shrink = true
          ..addTestId('todoLocalShell.blockContent')
        )(
          'Want to save and share your todos? ',
          (Dom.a()
            ..href = '/login'
            ..addTestId('todoLocalShell.login')
          )('Sign in now.'),
        ),
        (Block()..addTestId('todoLocalShell.block'))(props.children),
      ),
    );
   }
}