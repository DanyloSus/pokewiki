import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokewiki/bloc/cubits/page_cubit.dart';
import 'package:pokewiki/bloc/cubits/theme_cubit.dart';
import 'package:pokewiki/bloc/cubits/user_cubit.dart';
import 'package:pokewiki/main.dart';
import 'package:pokewiki/widgets/pokemon_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  getData() {
    BlocProvider.of<UserCubit>(context).loadValues();
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
    return Query(
      options: QueryOptions(document: gql(pokemonsGraphQL)),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final pokemonList = result.data?['pokemon_v2_pokemon'];

        return Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<UserCubit, String>(
                    builder: (context, username) {
                      return TextButton(
                        onPressed: () {
                          context.read<PageCubit>().changePage(0);
                        },
                        child: Text(
                          username,
                          style: GoogleFonts.dmSerifDisplay(
                            textStyle: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: context.read<ThemeCubit>().toogle,
                    icon: const Icon(
                      Icons.brightness_medium,
                    ),
                  )
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: [
                    ...pokemonList.map(
                      (e) => PokemonCard(
                        name: e['name'],
                        image: e['pokemon_v2_pokemonsprites'][0]['sprites']
                                ['other']['home']['front_default'] ??
                            "https://upload.wikimedia.org/wikipedia/commons/5/5a/Black_question_mark.png",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
