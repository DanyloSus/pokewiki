import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokewiki/bloc/cubits/page_cubit.dart';
import 'package:pokewiki/bloc/cubits/theme_cubit.dart';
import 'package:pokewiki/bloc/cubits/user_cubit.dart';
import 'package:pokewiki/widgets/pages/login.dart';
import 'package:pokewiki/widgets/pages/main.dart';

import 'bloc/observer.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(
    255,
    211,
    83,
    55,
  ),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(
    255,
    253,
    210,
    60,
  ),
);
// const Color.fromARGB(255,236, 233, 240,)
// const Color.fromARGB(255,103, 114, 128,)
var lightTheme = ThemeData.light().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.onPrimaryContainer,
    foregroundColor: kColorScheme.primaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
    ),
  ),
  textTheme: ThemeData()
      .textTheme
      .copyWith(
        displayLarge: GoogleFonts.dmSerifDisplay(
          textStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      )
      .apply(bodyColor: Colors.black),
);

var darkTheme = ThemeData.dark().copyWith(
  colorScheme: kDarkColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.onPrimaryContainer,
    foregroundColor: kDarkColorScheme.primaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
);

const pokemonsGraphQL = """
query samplePokeAPIquery {
  pokemon_v2_pokemon(order_by: {id: asc}) {
    id
    name
    pokemon_v2_pokemonsprites(where: {sprites: {_gte: "front_default"}}) {
      sprites
    }
  }
}
""";

void main() {
  Bloc.observer = const AppBlocObserver();

  final HttpLink httpLink = HttpLink("https://beta.pokeapi.co/graphql/v1beta/");

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    ),
  );

  var app = GraphQLProvider(
    client: client,
    child: const MyApp(),
  );

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageCubit>(
          create: (_) => PageCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  getData() {
    BlocProvider.of<PageCubit>(context).loadValues();
    BlocProvider.of<ThemeCubit>(context).loadValues();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, int>(
      builder: (_, pageIndex) => BlocBuilder<ThemeCubit, bool>(
        builder: (_, isLight) => MaterialApp(
          theme: isLight ? lightTheme : darkTheme,
          home: Scaffold(
            appBar: pageIndex > 0
                ? AppBar(
                    title: const Text(
                      "Pokemon Wiki",
                    ),
                  )
                : null,
            body: pageIndex == 0 ? const LoginPage() : const MainPage(),
          ),
        ),
      ),
    );
  }
}
