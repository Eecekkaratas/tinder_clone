import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone/Provider/card_provider.dart';
import 'package:tinder_clone/Widget/tinder_card.dart';
import 'package:tinder_clone/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: (ThemeData(
            primarySwatch: Colors.pink,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 8,
                primary: Colors.white,
                shape: CircleBorder(),
                minimumSize: Size.square(80),
              ),
            ),
          )),
          home: const MyHomePage(),
        ),
        //home: TinderCard(user: user),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*final user = User(
      name: 'Elif',
      age: 20,
      urlImage:
          'https://images.pexels.com/photos/13193116/pexels-photo-13193116.jpeg?auto=compress&cs=tinysrgb&w=400&lazy=load');
*/
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: buildCards(),
                ),
                const SizedBox(height: 16),
                buildButtons(),
              ],
            ),
          ),
        ),
      );

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImage;
    final names = provider.name;

    return urlImages.isEmpty
        ? Center(
            child: ElevatedButton(
            child: Text("Restart"),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.resetUser();
            },
          ))
        : Stack(
            children: urlImages
                .map(
                  (urlImage) => TinderCard(
                    urlImage: urlImage,
                    isFront: urlImages.last == urlImage,
                    name: '',
                  ),
                )
                .toList(),
          );
  }

  /*@override
  Widget build(
          BuildContext
              context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade200,
              Colors.black,
            ],
          ),
        ),
        child: 
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: TinderCard(user: user),
                ),
                const SizedBox(height: 16),
                buildButtons(),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
  );*/
  Widget buildLogo() => Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 36,
          ), // Icon
          const SizedBox(width: 4),
          Text(
            'Tinder',
            style: TextStyle(
              fontSize: 36,
              //fontWeight: Fontweight.bold,
              color: Colors.white,
            ), // TextStyle
          ),
        ],
      );
  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };
    return MaterialStateProperty.resolveWith(getBorder);
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImage;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDisLike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return urlImages.isEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.resetUser();
            },
            child: Text(
              'Resart',
              style: TextStyle(color: Colors.black),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.red, Colors.white, isDisLike),
                  backgroundColor:
                      getColor(Colors.white, Colors.red, isDisLike),
                  side: getBorder(Colors.red, Colors.white, isDisLike),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.dislike();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 46,
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        getColor(Colors.blue, Colors.white, isSuperLike),
                    backgroundColor:
                        getColor(Colors.white, Colors.blue, isSuperLike),
                    side: getBorder(Colors.blue, Colors.white, isSuperLike),
                  ),
                  onPressed: () {
                    final provider =
                        Provider.of<CardProvider>(context, listen: false);
                    provider.superlike();
                  },
                  child: Icon(
                    Icons.star,
                    color: Colors.blue,
                    size: 46,
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        getColor(Colors.teal, Colors.white, isLike),
                    backgroundColor:
                        getColor(Colors.white, Colors.teal, isLike),
                    side: getBorder(Colors.transparent, Colors.white, isLike),
                  ),
                  onPressed: () {
                    final provider =
                        Provider.of<CardProvider>(context, listen: false);
                    provider.like();
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.teal,
                    size: 46,
                  ))
            ],
          ); // Text
  }
}
