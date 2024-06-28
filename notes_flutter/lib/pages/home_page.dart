import 'package:flutter/material.dart';
import 'package:notes_client/notes_client.dart';
import 'package:notes_flutter/main.dart';
import 'package:notes_flutter/pages/loading_screen.dart';
import 'package:notes_flutter/pages/note_dialog.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List<Note>? _notes;
  Exception? _connectionException;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _notes == null
        ? LoadingScreen(
          exception: _connectionException,
          onTryAgain: _loadNotes
          )
        : ListView.builder(
          itemCount: _notes!.length,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Text(_notes![index].text),
            );
          }),
        ),

        floatingActionButton: _notes == null
          ? null
          : FloatingActionButton(
            onPressed: () {
              showNoteDialog(
                context: context,
                onSaved: (text) {
                  var note = Note(
                    text: text,
                  );
                  _notes!.add(note);
                  _createNote(note);
                }
              );
            },
            child: const Icon(Icons.add),
          ), 
    );
  }
}
