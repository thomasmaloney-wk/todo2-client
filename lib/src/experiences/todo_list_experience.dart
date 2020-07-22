import 'package:over_react/over_react.dart';
import 'package:todo2_client/src/module.dart';
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:wdesk_sdk/experience_framework.dart';
import 'package:w_router/w_router.dart';
import 'package:web_skin_dart/ui_components.dart';

Future<TodoListExperience> todoListExperienceFactory(AppContext appContext,
    FactoryContext factoryContext, ExperienceContext experienceContext) {
  final sdk = WdeskTodoSdk(appContext.natsMessagingClient);
  return Future.value(
      TodoListExperience(appContext.navigator, experienceContext.router, sdk));
}

class TodoListExperience extends DrawerExperience {
  @override
  final String name = 'TodoListExperience';

  DrawerContentComponent _drawerComponent;
  Navigator _navigator;
  Router _router;
  TodoSdk _sdk;
  DrawerHeaderComponent _drawerHeaderComponent;

  TodoListExperience(this._navigator, this._router, this._sdk) {
    _router.addRoute(name: 'root', path: '');
  }

  @override
  Future onLoad() async {
    final todoModule = TodoModule(_sdk);
    await loadChildModule(todoModule);

    _drawerComponent =
        DrawerContentComponent(content: todoModule.components.content);
    await addComponent(todoModule, _drawerComponent);
    _drawerHeaderComponent = DrawerHeaderComponent(
        icon: () => drawerHeaderIconFactory(IconGlyph.TWFR_ACTION_PLAN),
        title: () => Dom.span()('Todo List'));
    await addComponent(
        todoModule,
        _drawerHeaderComponent
        );
  }

  @override
  bool shouldShellRemoveComponent(ShellComponent component) {
    if (component == _drawerComponent) {
      var shouldUnloadResult = shouldUnload();
      if (!shouldUnloadResult.shouldUnload) {
        return false;
      }
    }
    return true;
  }
}
