import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController addController = TextEditingController();
  String searchEvents = " ";
  String capitalizeFirstLetter(String str) =>
      str[0].toUpperCase() + str.substring(1);

  String convertToTitleCase(String text) {
    if (text == null) {
      return "";
    }
    if (text.length <= 1) {
      return text.toUpperCase();
    }
    final List<String> words = text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });
    return capitalizedWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      style: GoogleFonts.lato(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.pinkAccent,
                      controller: addController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF283240),
                        contentPadding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                        suffixIcon: IconButton(
                          color: Color(0xFFB85E7C),
                          padding: EdgeInsets.only(right: 20),
                          icon: Icon(Icons.clear),
                          onPressed: () => addController.clear(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        hintText: "Search for event, Type T",
                        hintStyle: GoogleFonts.lato(
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchEvents = val.toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 30,
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF283240),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchEvents == null || searchEvents == "")
                    ? FirebaseFirestore.instance
                        .collection('events')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('events')
                        .where('searchIndex', arrayContains: searchEvents)
                        .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : (snapshot.connectionState != ConnectionState.none)
                          ? ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data!.docs[index];
                                return Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(data['eimage']),
                                        ),
                                        title: Text(
                                          convertToTitleCase(
                                              data['ename'].toString()),
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Color(0xFFB85E7C),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          data['etitle'],
                                          // convertToTitleCase(
                                          //     data['etitle'].toString()),
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            height: 1.5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Text(
                              "No data found",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
