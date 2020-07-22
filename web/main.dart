import 'dart:html';

import 'package:app_intelligence/app_intelligence_browser.dart' as ai;
import 'package:messaging_sdk/messaging_sdk.dart'
    show FrontendConfig, NatsMessagingClient;
import 'package:over_react/over_react.dart';
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:react/react_dom.dart' as react_dom;
import 'package:todo2_client/src/experience_registry/todo_experience_registry.dart';
import 'package:w_session/mock.dart';
import 'package:w_session/w_session.dart';
import 'package:wdesk_sdk/alpha/alpha.dart';
import 'package:wdesk_sdk/app_infrastructure.dart';
import 'package:w_transport/browser.dart';
import 'package:w_transport/mock.dart';
import 'package:wdesk_sdk/experience_framework.dart';
import 'package:wdesk_sdk/truss.dart';
// Added to enable React component debugging via $r in the Dartium dev tools.
// ignore: unused_import
import 'package:web_skin_dart/ui_core.dart' show $r;
import 'package:over_react/components.dart' as orc;

Future main() async {
  setClientConfiguration();
  configureWTransportForBrowser();

  final experienceRegistry = TodoExperienceRegistry();
  var sessionHost = Environment.current.iamHost;

  final isDebug = Environment.current.deploy == Deploy.localhost;
  final appIntelligence = ai.AppIntelligence('todo2_client',
      applySourceMaps: true,
      appVersion: Environment.current.version,
      captureMemory: true,
      captureTimeInApp: false,
      captureTotalAppRunningTime: false,
      isDebug: isDebug,
      withTracing: false);

  if (Environment.current.mockAuth) {
    MockSession.install();
    MockTransports.install(fallThrough: true);
    MockSession.sessionHost = Uri.parse('http://localhost:8001');
    MockSession.source.accountResourceId = 'QWNjb3VudB8xMTE';
    MockSession.source.membershipResourceId = 'TWVtYmVyc2hpcB8yMjI=';
    MockSession.source.userResourceId = 'V0ZVc2VyHzMzMw==';
    MockSession.source.email = 'jon.snow@workiva.com';
    MockSession.source.membershipPreferences.enableWorkspaces = false;
    enableTestMode();
  } else if (Environment.current.isAutomated) {
    enableTestMode();
  }

  // Setup the session and load the shell (which handles starting the session).
  final session = Session(sessionHost: sessionHost, scope: experienceRegistry.oauth2Scopes);
  final shell = WdeskShell(session: session, appIntelligence: appIntelligence);
  await shell.load();

  // determine the messaging frontend uri
  Uri currentUri = Uri.parse(window.location.href);
  String messagingFrontendUri = 'http://localhost:8100';
  if (isDebug && currentUri.queryParameters['wkdev'] == 'true') {
      messagingFrontendUri = 'https://messaging.wk-dev.wdesk.org';
  }

  // Establish a messaging connection.
  final frontendConfig = FrontendConfig(messagingFrontendUri);
  final natsMessagingClient = NatsMessagingClient(session, frontendConfig);
  await natsMessagingClient.open();

  // Instantiate the authenticated & authorized to-do SDK.
  //final todoSdk = WdeskTodoSdk(natsMessagingClient);

  // Inject the service into our to-do module.
  //final todoModule = TodoModule(todoSdk);

  // Grab the main to-do UI, but hide the filter since we'll be placing a
  // variation of the filter in the workspaces sidebar.
  //var mainContent = todoModule.components.content(
  //    currentUserId: session.context.userResourceId, withFilter: false);

  // Construct the entire application component to render using the shell's
  // content factory.
//  var component = shell.components.content(
//      // Main content area of the shell.
//      content: mainContent,
//      // Populate the workspaces sidebar with a variant of the to-do filter.
//      menuContent: todoModule.components.sidebar(),
//      // Hide the create menu.
//      menuHeader: null);

  var appRouter = WdeskRouter();  //Router(useFragment: false);
  NestedDrawerExperienceApi.configure(appRouter);
  var app = WdeskApp(
      experienceRegistry: experienceRegistry,
      natsMessagingClient: natsMessagingClient,
      router: appRouter,
      showNetworkHealthAlerts: true,
      wdeskShell: shell);
  await app.load();

  final component =
      shell.components.content(menuHeader: WorkspacesHeaderButtonGroup()(
        app.components.createMenu(),
      ),
        menuContent: app.components.sidebarMenu(),
        menuFooter: app.components.sidebarFooter(),);
  final container = querySelector('#shell-container');
  react_dom.render(orc.ErrorBoundary()(component), container);
}
