import 'dart:html';

import 'package:messaging_sdk/messaging_sdk.dart'
    show FrontendConfig, NatsMessagingClient;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:react/react_dom.dart' as react_dom;
import 'package:todo2_client/todo_client.dart' show TodoModule;
import 'package:todo2_sdk/todo2_sdk.dart';
import 'package:w_session/w_session.dart';
import 'package:wdesk_sdk/experience_framework.dart';
import 'package:wdesk_sdk/truss.dart';
// Added to enable React component debugging via $r in the Dartium dev tools.
// ignore: unused_import
import 'package:web_skin_dart/ui_core.dart' show $r;

main() async {
  setClientConfiguration();

  // Setup the session and load the shell (which handles starting the session).
  final session = Session(sessionHost: Environment.current.iamHost);
  final shell = WorkspacesShell(session: session);
  await shell.load();

  // Establish a messaging connection.
  final frontendConfig = FrontendConfig('http://localhost:8100');
  final natsMessagingClient = NatsMessagingClient(session, frontendConfig);
  await natsMessagingClient.open();

  // Instantiate the authenticated & authorized to-do SDK.
  final todoSdk = WdeskTodoSdk(natsMessagingClient);

  // Inject the service into our to-do module.
  final todoModule = TodoModule(todoSdk);

  // Grab the main to-do UI, but hide the filter since we'll be placing a
  // variation of the filter in the workspaces sidebar.
  var mainContent = todoModule.components.content(
      currentUserId: session.context.userResourceId, withFilter: false);

  // Construct the entire application component to render using the shell's
  // content factory.
  var component = shell.components.content(
      // Main content area of the shell.
      content: mainContent,
      // Populate the workspaces sidebar with a variant of the to-do filter.
      menuContent: todoModule.components.sidebar(),
      // Hide the create menu.
      menuHeader: null);

  final container = querySelector('#shell-container');
  react_dom.render(component, container);
}
