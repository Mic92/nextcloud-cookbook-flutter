import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/repository.dart';

class RecipesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipesListScreenState();
}

class RecipesListScreenState extends State<RecipesListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesShortBloc, RecipesShortState> (
      builder: (context, recipesShortState) {
        return Scaffold(
          body: (() {
            if (recipesShortState is RecipesShortLoadSuccess) {
              return _buildRecipesShortScreen(recipesShortState.recipesShort);
            } else if (recipesShortState is RecipesShortLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Text("RIP");
            }
          }()),
        );
      },
    );
  }


  ListView _buildRecipesShortScreen(List<RecipeShort> data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildRecipeShortScreen(data[index]);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
    );
  }

  ListTile _buildRecipeShortScreen(RecipeShort data) {
    return ListTile(
      title: Text(data.name),
      trailing: RecipesShortProvider().fetchRecipeThumb(data.imageUrl),
      onTap: () => print(data.name),
    );
  }
}