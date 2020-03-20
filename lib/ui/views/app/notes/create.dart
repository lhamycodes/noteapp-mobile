import 'package:flutter/material.dart';
import 'package:noteapp/ui/widgets/busy_overlay.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../../shared/ui_helpers.dart';
import '../../../shared/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../../viewmodels/note_view_model.dart';

class CreateNote extends StatefulWidget {
  static const routeName = '/app/notes/create';

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NoteViewModel>.withConsumer(
      viewModel: NoteViewModel(),
      onModelReady: (model) => {},
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        title: "Creating",
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  model.create();
                },
                icon: Icon(Icons.check),
                label: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textColor: primaryColor,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "NotesApp",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      " - Create",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
                verticalSpace(15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        label: "Title",
                        hintText: "Hello World",
                        keyboardAction: TextInputAction.next,
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          model.noteData['title'] = val;
                        },
                      ),
                      verticalSpace20,
                      CustomTextField(
                        label: "Description",
                        hintText: "lorem ipsum dolor sit amit .....",
                        keyboardAction: TextInputAction.done,
                        minLines: 25,
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          model.noteData['description'] = val;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
