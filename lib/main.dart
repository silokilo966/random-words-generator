import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions =
      <WordPair>[]; //Storing the word pairs in the _suggestions variable
  final _saved = <WordPair>{}; //This stores the wordpairs that user favorited
  final _biggerFonts = TextStyle(
      fontSize: 16.0); //storing the text style in _biggerFonts variable

  //_pushSaved Function

  Widget _buildSuggestions() {
    return ListView.builder(
        //using Listview.builder (builder creates list only when required)
        //compared to ListView which creates all on the spot
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd)
            return const Divider(); //First line will be pair of words, 2nd will be Divider (space line)

          final index = i ~/
              2; //dividing number of rows by 2 (bcz we dont want to count the divider lines also)
          if (index >= _suggestions.length) {
            //if no. of created wordpairs >= to no. of wordpairs in _suggestions
            _suggestions.addAll(generateWordPairs().take(
                10)); //Then create 10 more (means it'll always create wordpairs)
          } //as we used Listview.Builder (it will only be created when required instead of creating infinit wordpairs)
          return _buildRow(_suggestions[index]); //calling _buildRow
        });
  }

  Widget _buildRow(WordPair pair) {
    //We use this to style our List of word pairs
    final alreadySaved = _saved.contains(
        pair); // an alreadySaved check to ensure that a word pairing has not already been added to favorites.
    return ListTile(
      //ListTile is used to style individual list item (wordpair) then we use it for all wordpairs
      title: Text(
        pair.asPascalCase,
        style: _biggerFonts,
      ),
      trailing: Icon(
        //Add an icon after each word pair
        alreadySaved
            ? Icons.favorite
            : Icons
                .favorite_border, //if alreadySaved = true (add icons.favorite) else add Icons.Favorite_border
        color: alreadySaved
            ? Colors.red
            : null, // if alreadySaved = set color red else null
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          //Actions are icons at the Right side of AppBar
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          IconButton(onPressed: null, icon: Icon(Icons.ac_unit))
        ],
      ),
      body: _buildSuggestions(), //Function
    );
  }

  void _pushSaved() {
    Navigator.of(context) //pushes the route to the navigators stack
        .push(MaterialPageRoute(builder: (BuildContext context) {
      //A modal route that replaces the entire screen with a platform-adaptive transition.
      //builder defines the contents for MaterialPageRoute
      final tiles = _saved.map((WordPair pair) {
        //_saved contains the wordpairs we favorited, .map creates a map/copy of it and we save it to tiles variable
        return ListTile(
          //.map returns a ListTile, we configure the ListTile which will be showed in the new screen
          title: Text(
            pair.asPascalCase,
            style: _biggerFonts,
          ),
        );
      });
      final divided = tiles
              .isNotEmpty //creaeting a Divided variable and assigning tiles(_saved.map) to it, but making sure its not empty
          ? ListTile.divideTiles(context: context, tiles: tiles)
              .toList() //creating a ListTile and using divideTiles *which adds divider after every tile(_saved.map item)
          : <Widget>[]; //else Add <Widget>[]

      return Scaffold(
          //the builder returns something, we return scaffold for the new page (as i said the builder defines the contents for MaterialPageRoute)
          appBar: AppBar(
            title: Text("Saved Suggestions"),
          ),
          body: ListView(
              //The ListTile is shown here
              children:
                  divided) //in the body of new page, we show the ListView with the divided lines as children
          );
    }));
  }
}
