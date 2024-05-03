import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatBloc.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeBloc.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/chat_services.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/core/view_model/sector_view_model.dart';
import 'package:sevenapplication/screens/connection_screen.dart';
import 'package:sevenapplication/screens/employer/employer_informations.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_entreprise.dart';
import 'package:sevenapplication/screens/user_bank_account.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_profil.dart';
import 'package:sevenapplication/screens/employer/employer_register.dart';
import 'package:sevenapplication/screens/employer/home_employer/add_mission/add_mission_last.dart';
import 'package:sevenapplication/screens/employer/home_employer/add_mission/select_date_time_screen.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_missions.dart';
import 'package:sevenapplication/screens/employer/home_employer/home_page_employer.dart';
import 'package:sevenapplication/screens/home_screen.dart';
import 'package:sevenapplication/screens/register_screen.dart';
import 'package:sevenapplication/screens/reset_id_screen.dart';
import 'package:sevenapplication/screens/worker/home_worker/home_page_worker.dart';
import 'package:sevenapplication/screens/worker/home_worker/search_page.dart';
import 'package:sevenapplication/screens/worker/home_worker/worker_entreprise.dart';
import 'package:sevenapplication/screens/worker/worker_informations.dart';
import 'package:sevenapplication/screens/worker/home_worker/worker_profil.dart';
import 'package:sevenapplication/screens/worker/worker_register.dart';
import 'package:sevenapplication/splashScreen.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';

import 'screens/employer/home_employer/components/metiers_list.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return HomeScreen();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterScreen(),
          /* builder: (BuildContext context, GoRouterState state) {
            return const RegisterScreen();
          }, */
        ),
        GoRoute(
          path: 'employer',
          builder: (BuildContext context, GoRouterState state) {
            return const EmployerRegister();
          },
        ),
        GoRoute(
          path: 'worker',
          builder: (BuildContext context, GoRouterState state) {
            return const WorkerRegister();
          },
        ),
        GoRoute(
          path: 'information_employer',
          builder: (BuildContext context, GoRouterState state) {
            return const EmployerInformation();
          },
        ),
        GoRoute(
          path: 'information_worker',
          builder: (BuildContext context, GoRouterState state) {
            return const WorkerInformation();
          },
        ),
        GoRoute(
          path: 'connection',
          builder: (BuildContext context, GoRouterState state) {
            return const ConnectionScreen();
          },
        ),
        GoRoute(
          path: 'reset_id',
          builder: (BuildContext context, GoRouterState state) {
            return const ResetIds();
          },
        ),
        GoRoute(
          name: "ProfilEmployer",
          path: "EmployerProfil",
          builder: (context, state) {
            ParseUser? user = state.extra as ParseUser?;
            return EmployerProfil(utilisateur: user);
          },
        ),
        GoRoute(
          name: "HomeEmployer",
          path: 'home_employer_page',
          builder: (BuildContext context, GoRouterState state) {
            ParseUser? currentUser = state.extra as ParseUser?;
            return HomePageEmployer(utilisateur: currentUser);
          },
        ),
        GoRoute(
          name: "EmployerEntreprise",
          path: "EmployerEntreprise",
          builder: (context, state) {
            ParseUser? currentUser = state.extra as ParseUser?;
            return EmployerEntreprise(utilisateur: currentUser);
          },
        ),
        GoRoute(
          name: "ProfilWorker",
          path: "WorkerProfil",
          builder: (context, state) {
            ParseUser? user = state.extra as ParseUser?;
            return WorkerProfil(utilisateur: user);
          },
        ),
        GoRoute(
          name: "HomeWorker",
          path: 'home_worker_page',
          builder: (BuildContext context, GoRouterState state) {
            ParseUser? currentUser = state.extra as ParseUser?;
            return HomePageWorker(utilisateur: currentUser);
          },
        ),
        GoRoute(
          name: "WorkerEntreprise",
          path: "WorkerEntreprise",
          builder: (context, state) {
            ParseUser? currentUser = state.extra as ParseUser?;
            return WorkerEntreprise(utilisateur: currentUser);
          },
        ),
        GoRoute(
          path: 'dateScreen',
          builder: (BuildContext context, GoRouterState state) {
            return SelectDateTimeScreen();
          },
        ),
        GoRoute(
          path: 'addMissionLastPage',
          builder: (BuildContext context, GoRouterState state) {
            return AddMissionLast();
          },
        ),
        GoRoute(
          path: 'employer_missions',
          builder: (BuildContext context, GoRouterState state) {
            return EmployerMissions();
          },
        ),
        GoRoute(
          path: 'metiersList',
          builder: (BuildContext context, GoRouterState state) {
            return MetiesList();
          },
        ),
        GoRoute(
          name: "searchMissions",
          path: 'searchMissionsPath',
          builder: (BuildContext context, GoRouterState state) {
            return SearchMissionsPage(state.extra as String);
          },
        ),
        GoRoute(
          name: "BankUser",
          path: "EmployerBank",
          builder: (context, state) {
            ParseUser? user = state.extra as ParseUser?;
            return UserRIB(utilisateur: user);
          },
        )
      ],
    ),
  ],
  initialLocation: '/',
);

class SevenJobs extends StatelessWidget {
  SevenJobs({super.key});

  final UserDataRepository userDataRepository = UserDataRepository();
  final ChatRepository chatRepository = ChatRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ChatBloc>(
            create: (_) => ChatBloc(
                userDataRepository: userDataRepository,
                chatRepository: chatRepository),
          ),
          BlocProvider<HomeConversationBloc>(
            create: (_) => HomeConversationBloc(chatRepository: chatRepository),
          ),
        ],
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => SectorViewModel()),
            ],
            child: ScreenUtilInit(
                designSize: const Size(390, 844),
                builder: () => MaterialApp.router(
                      title: ConstApp.appName,
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: [
                        FormBuilderLocalizations.delegate,
                        ...GlobalMaterialLocalizations.delegates,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      supportedLocales:
                          FormBuilderLocalizations.supportedLocales,
                      theme: ThemeData(
                        brightness: Brightness.light,
                        primaryColor: ColorsConst.col_app,
                        fontFamily: ConstApp.fontfamily,
                      ),
                      routerConfig: _router,
                    ))));
  }
}
