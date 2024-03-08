import 'package:flutter/cupertino.dart';
import 'package:syncflow/archive/archive_page.dart';
import 'package:syncflow/assignee/project_detail_add_task_select_assignees_page.dart';
import 'package:syncflow/contributor/add_contributor_page.dart';
import 'package:syncflow/home/home_page.dart';
import 'package:syncflow/mention/mention_page.dart';
import 'package:syncflow/profile/profile_page.dart';
import 'package:syncflow/project/new_project_contributors_page.dart';
import 'package:syncflow/project/new_project_page.dart';
import 'package:syncflow/project/new_project_status_page.dart';
import 'package:syncflow/project/new_project_tags_page.dart';
import 'package:syncflow/project/project_detail_page.dart';
import 'package:syncflow/project/project_page.dart';
import 'package:syncflow/root/root_page.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/status/add_status_page.dart';
import 'package:syncflow/status/project_detail_add_task_select_status_page.dart';
import 'package:syncflow/status/status_detail_page.dart';
import 'package:syncflow/tag/add_tag_page.dart';
import 'package:syncflow/tag/project_detail_add_task_select_tags_page.dart';
import 'package:syncflow/tag/tag_detail_page.dart';
import 'package:syncflow/task/project_detail_add_task_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorProjectKey = GlobalKey<NavigatorState>(debugLabel: 'shellProject');
final _shellNavigatorArchiveKey = GlobalKey<NavigatorState>(debugLabel: 'shellArchive');
final _shellNavigatorMentionKey = GlobalKey<NavigatorState>(debugLabel: 'shellMention');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final router = GoRouter(initialLocation: "/", navigatorKey: _rootNavigatorKey, debugLogDiagnostics: true, routes: [
  StatefulShellRoute(
      builder: (context, state, navigationShell) {
        return navigationShell;
      },
      navigatorContainerBuilder: (context, navigationShell, children) {
        return Root(navigationShell: navigationShell, children: children);
      },
      branches: [
        StatefulShellBranch(navigatorKey: _shellNavigatorHomeKey, routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          // GoRoute(
          //   path: '/users/:username',
          //   builder: (context, state) => GitHubUserPage(username: state.pathParameters['username']!),
          // ),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorProjectKey, routes: [
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectPage(),
            routes: <RouteBase>[
              GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'new',
                  builder: (context, state) => const NewProjectPage(),
                  routes: <RouteBase>[
                    GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'contributors',
                        builder: (context, state) => const NewProjectContributorsPage(),
                        routes: <RouteBase>[
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'new',
                            builder: (context, state) => const AddContributorPage(),
                          ),
                        ]),
                    GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'status',
                        builder: (context, state) {
                          return const NewProjectStatusPage();
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'new',
                            builder: (context, state) => const AddStatusPage(),
                          ),
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: ':statusID',
                            builder: (context, state) => StatusDetailPage(
                              statusID: state.pathParameters["statusID"]!,
                            ),
                          )
                        ]),
                    GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'tags',
                        builder: (context, state) => const NewProjectTagsPage(),
                        routes: <RouteBase>[
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'new',
                            builder: (context, state) => const AddTagPage(),
                          ),
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: ':tagID',
                            builder: (context, state) => TagDetailPage(
                              tagID: state.pathParameters["tagID"]!,
                            ),
                          )
                        ])
                  ]),
              GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: ':projectID',
                  builder: (context, state) => ProjectDetailPage(
                        id: state.pathParameters["projectID"]!,
                      ),
                  routes: [
                    GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'tasks/new',
                        builder: (context, state) => ProjectDetailAddTaskPage(
                              projectID: state.pathParameters["projectID"]!,
                            ),
                        routes: [
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'status',
                            builder: (context, state) =>
                                ProjectDetailAddTaskSelectStatusPage(projectID: state.pathParameters["projectID"]!),
                          ),
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'tags',
                            builder: (context, state) =>
                                ProjectDetailAddTaskSelectTagsPage(projectID: state.pathParameters["projectID"]!),
                          ),
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'assignees',
                            builder: (context, state) =>
                                ProjectDetailAddTaskSelectAssigneesPage(projectID: state.pathParameters["projectID"]!),
                          ),
                        ])
                  ])
            ],
          ),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorArchiveKey, routes: [
          GoRoute(path: '/archives', builder: (context, state) => const ArchivePage()),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorMentionKey, routes: [
          GoRoute(path: '/mentions', builder: (context, state) => const MentionPage()),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorProfileKey, routes: [
          GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
        ]),
      ])
]);
