import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';



void main() => runApp(const MyApp());



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scratch Cards',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'SpecialElite'
          )
      ),
      home: const SelectionPage(),
    );
  }
}




///=====================================================
/// SELECTION PAGE
///=====================================================
class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectionPage();
}


class _SelectionPage extends State<SelectionPage>{
  final List<Person> _persons = _makePersonsList();

  _makeButtons(List<Person> persons) {
    List<MyButton> myButtons = [];
    for (Person person in persons) {
      myButtons.add(MyButton(person: person, context: context));
    }
    return myButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                  'Who are you?',
                  style: TextStyle(fontSize: 40, color: Colors.white70)
              ),
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _makeButtons(_persons),
                  )
              )
            ]
        )
      )
    );
  }
}




///=====================================================
/// MY BUTTON
///=====================================================
class MyButton extends StatelessWidget {
  final Person person;
  final BuildContext context;

  const MyButton({super.key, required this.person, required this.context});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
        ),
        onLongPress: () {
          _pushPerson(context, person);
        },
        onPressed: () {  },
        child: Text(
          person.name,
          style: const TextStyle(fontSize: 30)
        )
    );
  }
  

  void _pushPerson(BuildContext context, Person person) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => MyHomePage(person: person))
    );
  }
}




///=====================================================
/// SCRATCHER PAGE
///=====================================================
class MyHomePage extends StatefulWidget {
  final Person person;
  const MyHomePage({super.key, required this.person});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  final scratchKey = GlobalKey<ScratcherState>();
  int _scratchLevel = 0;

  void _onThresholdReached() {
    if (_scratchLevel >= widget.person.sentences.length - 1) {
      return;
    }
    setState(() {
      _scratchLevel++;
      if (scratchKey.currentState != null) {
        scratchKey.currentState!.reset(duration: const Duration(milliseconds: 500));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody()
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget _buildBody() {
    return Center(
        child: MyScratcher(
          scratchLevel: _scratchLevel,
          onThresholdReached: _onThresholdReached,
          scratchKey: scratchKey,
          person: widget.person
        )
    );
  }
}




///=====================================================
/// SCRATCHER
///=====================================================
class MyScratcher extends StatelessWidget {
  final int scratchLevel;
  final Function() onThresholdReached;
  final GlobalKey<ScratcherState> scratchKey;
  final Person person;
  final double _threshold = 50;

  const MyScratcher({
    key,
    required this.scratchLevel,
    required this.onThresholdReached,
    required this.scratchKey,
    required this.person,
  }) : super(key: key);


  double _getThreshold(int scratchLevel) {
    if (scratchLevel >= person.sentences.length - 2) {
      return 95;
    } else {
      return _threshold;
    }
  }

  Widget _makeBehindScratch(BuildContext context, int scratchLevel) {
    if (scratchLevel < person.sentences.length - 1) {
      return Text(
        person.sentences[scratchLevel],
        style: Theme
            .of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black54),
        textAlign: TextAlign.center,
      );
    }
    else {
      return DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/backgr_picture.jpg'),
                fit: BoxFit.cover
            )
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                person.sentences[scratchLevel],
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scratcher(
      key: scratchKey,
      brushSize: 40,
      threshold: _getThreshold(scratchLevel),
      color: Colors.black,
      onThreshold: onThresholdReached,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        alignment: Alignment.center,
        child: _makeBehindScratch(
            context,
            scratchLevel
        )
      )
    );
  }
}




///=====================================================
/// PERSONS
///=====================================================
class Person {
  final String name;
  final List<String> sentences;

  const Person({required this.name, required this.sentences});

  String getName() {
    return name;
  }

  List<String> getSentences() {
    return sentences;
  }
}



List<Person> _makePersonsList() {
  final List<String> sentences = [
    'Something has been planted,',
    'and it will grow into something beautiful.',
    'It is a special kind of growth,',
    'one that is nurtured and protected.',
    'As time goes on, changes will be noticeable,',
    'but for now, it remains a secret,',
    'just between me and whats growing.',
    'Each day brings new developments,',
    'and soon, the world will know.',
  ];
  final List<String> names = [
    'Tabea',
    'Jonathan',
    'Jakob',
    'Anne'
  ];

  List<Person> persons = [];
  for (String name in names) {
    List<String> personSentences = List.from(sentences);
    if (name == 'Jonathan' || name == 'Jakob') {
      personSentences.add('You´re gonna be an UNCLE!');
    }
    if (name == 'Tabea' || name == 'Anne') {
      personSentences.add('You´re gonna be an AUNT!');
    }
    persons.add(
      Person(name: name, sentences: personSentences)
    );
  }
  return persons;
}