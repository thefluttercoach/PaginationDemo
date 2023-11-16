import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'demo_app',
      home: MyHomePage(title: 'Demo App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List resultsList = [];
  int currentPage = 0;
  int resultsPerPage = 3;
  int startPage = 0;

  Uri randomWordsUrl =
      Uri.parse('https://random-word-api.herokuapp.com/word?number=20');

  Future<void> fetchRandomWords() async {
    try {
      final randomWordsResponse = await http.get(randomWordsUrl);
      if (randomWordsResponse.statusCode == 200) {
        var jsonRandomWords = jsonDecode(randomWordsResponse.body);
        setState(() {
          resultsList.addAll(jsonRandomWords);
        });
      } else {
        //
      }
    } catch (error) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          //button for fetching random words
          Center(
            child: ElevatedButton(
              onPressed: () => fetchRandomWords(),
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                foregroundColor: const MaterialStatePropertyAll(Colors.black),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: const Text('Fetch Random Words'),
            ),
          ),
          const SizedBox(height: 15),
          //cards for displaying random word results
          if (resultsList.isNotEmpty) Text('${resultsList.length} results'),
          if (resultsList.isNotEmpty)
            for (int i = 0;
                i <
                    min(resultsPerPage,
                        (resultsList.length - (currentPage * resultsPerPage)));
                i++)
              Card(
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Result ${((currentPage * resultsPerPage) + i) + 1}'),
                      const SizedBox(height: 5),
                      Text(
                        resultsList[(currentPage * resultsPerPage) + i],
                        style: const TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
      //pagination navigation section
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          //page numbering text
          if (resultsList.isNotEmpty)
            Text(
              'Page ${currentPage + 1} of ${(resultsList.length / resultsPerPage).ceil()}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 5),
          //page navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //first page button
              startPage > 0 &&
                      ((MediaQuery.of(context).size.width - 120) / 30).floor() <
                          (resultsList.length / resultsPerPage).ceil()
                  ? SizedBox(
                      width: 30,
                      child: IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: () {
                            setState(() {
                              startPage = 0;
                              currentPage = 0;
                            });
                          }),
                    )
                  : const SizedBox(),
              //move backward button
              startPage > 0 &&
                      ((MediaQuery.of(context).size.width - 120) / 30).floor() <
                          (resultsList.length / resultsPerPage).ceil()
                  ? SizedBox(
                      width: 30,
                      child: IconButton(
                        icon: const Icon(Icons.navigate_before),
                        onPressed: () {
                          setState(() {
                            startPage--;
                          });
                        },
                      ),
                    )
                  : const SizedBox(),
              //numbered page buttons
              for (int i = startPage;
                  i <
                      min(
                          (((MediaQuery.of(context).size.width - 120) / 30)
                                  .floor() +
                              startPage),
                          (resultsList.length / resultsPerPage).ceil());
                  i++)
                SizedBox(
                  width: 30,
                  height: 40,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor:
                        currentPage == i ? Colors.amber : Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentPage = i;
                        });
                      },
                      child: Text(
                        (i + 1).toString(),
                      ),
                    ),
                  ),
                ),
              //move forward button
              (resultsList.length / resultsPerPage).ceil() >
                          ((MediaQuery.of(context).size.width - 120) / 30)
                              .floor() &&
                      ((resultsList.length / resultsPerPage).ceil() -
                              startPage) >
                          ((MediaQuery.of(context).size.width - 120) / 30)
                              .floor()
                  ? SizedBox(
                      width: 30,
                      child: IconButton(
                          icon: const Icon(Icons.navigate_next),
                          onPressed: () {
                            setState(() {
                              startPage++;
                            });
                          }),
                    )
                  : const SizedBox(),
              //last page button
              (resultsList.length / resultsPerPage).ceil() >
                          ((MediaQuery.of(context).size.width - 120) / 30)
                              .floor() &&
                      ((resultsList.length / resultsPerPage).ceil() -
                              startPage) >
                          ((MediaQuery.of(context).size.width - 120) / 30)
                              .floor()
                  ? IconButton(
                      icon: const Icon(Icons.last_page),
                      onPressed: () {
                        setState(() {
                          startPage = (resultsList.length / resultsPerPage)
                                  .ceil() -
                              ((MediaQuery.of(context).size.width - 120) / 30)
                                  .floor();
                          currentPage =
                              (resultsList.length / resultsPerPage).ceil() - 1;
                        });
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
